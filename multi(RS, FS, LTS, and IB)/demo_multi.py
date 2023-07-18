import serial
import threading
import time
import matplotlib.pyplot as plt
from matplotlib import gridspec

# please specify the port name
PORT_NAME = "COM6"

# Parameters for serial communication
# If you change these parameters, you must also change the vhdl code on the FPGA
BAUD_RATE = 2000000 # 1000000 baud rate
NUM_DATA = 3        # a single signal (18-bits) is sent in 3 bytes
NUM_SIGNAL = 4      # two signals (v and I) are received
NUM_BIT = 18        # signals are represented by fixed-point 18 bits
DT = 0.0001         # time step of the simulation [s]
LF = 10             # line feed
SEND_TW = 0.1       # interval between data transmissions
REST_TIME = 1       # additional receive time

# global flag for controlling threads
receiver_stop_flag=0

# decode the received 3-byte data to a float value
def decoder(l0):
    x0=0
    for i in range(NUM_DATA):
        x0+=(l0[i]-2**7)*2**(7*(NUM_DATA-1-i))
    if x0>2**((NUM_BIT+3)-1):
        x0=x0-2**(NUM_BIT+3)
    return x0/2**13

# receiver for the serial communication
    # a packet is sent from the FPGA every DT seconds
    # a single packet is composed of following 13 byte data
    # ib0, ib1, ib2, lts0, lts1, lts2, rs0, rs1, rs2, fs0, fs1, fs2, LF
    # where vx and Ix are used to decode v and I, respectively
def receiver(ser):
    received_data=[]
    global receiver_stop_flag
    ser.reset_input_buffer()
    print("start receiving")
    while receiver_stop_flag == 0:
        if ser.in_waiting>0:
            line0 = ser.read(ser.in_waiting)
            received_data.extend(list(line0))
    print("start decoding")
    list_va=[]
    list_vb=[]
    list_vc=[]
    list_vd=[]
    
    t0=[]
    c0=0
    while received_data[0]!=10:
        received_data.pop(0)
    received_data.pop(0)
    
    for i in range(int(len(received_data)/(NUM_DATA*NUM_SIGNAL+1))):
        list_va.append(received_data[i*(NUM_DATA*NUM_SIGNAL+1):i*(NUM_DATA*NUM_SIGNAL+1)+NUM_DATA])
        list_vb.append(received_data[i*(NUM_DATA*NUM_SIGNAL+1)+NUM_DATA:i*(NUM_DATA*NUM_SIGNAL+1)+NUM_DATA*2])
        list_vc.append(received_data[i*(NUM_DATA*NUM_SIGNAL+1)+NUM_DATA*2:i*(NUM_DATA*NUM_SIGNAL+1)+NUM_DATA*3])
        list_vd.append(received_data[i*(NUM_DATA*NUM_SIGNAL+1)+NUM_DATA*3:i*(NUM_DATA*NUM_SIGNAL+1)+NUM_DATA*4])
        t0.append(c0*DT)
        c0=c0+1
    global gt,gva,gvb,gvc,gvd
    gt=t0
    gva=[]
    gvb=[]
    gvc=[]
    gvd=[]
    for i in range(len(list_va)):
        gva.append(decoder(list_va[i]))
        gvb.append(decoder(list_vb[i]))
        gvc.append(decoder(list_vc[i]))
        gvd.append(decoder(list_vd[i]))

# encode the float value (I) to 3-byte data
def encode_I(I):
    if I>=2**8 or I<=-2**8:
        raise ValueError('too large or too small input stimulus')
    if I<0:
        I=256+I
    I0=int(I)
    I1=int((I-I0)*2**8)
    I2=int((I-I0-I1/2**8)*2**10)
    return [I0, I1, I2]

# class for transmitter of the serial communication
    # a block of packets is sent to the FPGA every SEND_TW second and stored FIFO buffer
    # packets are processed every DT second in FPGA
    # when there is no command to process, the packet contains only LF
    # when I is to be changed, the packet contains the following 13 byte data
    # Iib0, Iib1, Iib2, Ilts0, Ilts1, Ilts2, Irs0, Irs1, Irs2, Ifs0, Ifs1, Ifs2, LF
    # where Ix are used to decode I that is a 18-bit signal
class send_data:
    def __init__(self,tmax):
        self.I_list=[]
        self.packet_list=[]
        self.tmax=tmax
    def set_I(self,t0,I0=0,I1=0,I2=0,I3=0):
        self.I_list.append([t0,I0,I1,I2,I3])
    def generate_packet_list(self):
        c0=0
        packet=[]
        for i in range(int((self.tmax+1)/DT)):
            for j, x in enumerate(self.I_list):
                if i==int(x[0]/DT):
                    print("inserted", i*DT, "[s], I=", x[1], x[2], x[3], x[4])
                    packet.extend(encode_I(x[1]))
                    packet.extend(encode_I(x[2]))
                    packet.extend(encode_I(x[3]))
                    packet.extend(encode_I(x[4]))
            packet.append(LF)
            if i%(int(SEND_TW/DT))==0:
                self.packet_list.append(packet)
                packet=[]
    def packet_get(self):
        if len(self.packet_list)>0:
            return self.packet_list.pop(0)

class serial_test:
    def __init__(self,tmax):
        self.tmax=tmax
        self.d0=send_data(tmax)
    def insert_I(self,t0,I0=0,I1=0,I2=0,I3=0):
        self.d0.set_I(t0,I0,I1,I2,I3)
    def run(self):
        self.d0.generate_packet_list()
        ser = serial.Serial(PORT_NAME, baudrate=BAUD_RATE, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE)
        ser.set_buffer_size(rx_size=12800, tx_size=12800)
        thread1 = threading.Thread(target=receiver, args=(ser,))
        thread1.start()
        t1=time.time()
        t2=time.time()
        k0=0
        ser.write(self.d0.packet_get())
        while t2-t1<self.tmax:
            ser.write(self.d0.packet_get())
            k0+=1
            t2=time.time()
            time.sleep(SEND_TW*k0-(t2-t1))
        global receiver_stop_flag
        time.sleep(REST_TIME)
        receiver_stop_flag=1
        thread1.join()
        ser.close()
        return gt,gva,gvb,gvc,gvd

if __name__ == "__main__":

    # length of simulation [s]
    tmax= 3 #3

    # set serial communication
    se0=serial_test(tmax)

    # set stimulus input
       # arg0: time [s]
       # arg1: magnitude of I
    se0.insert_I(0)
    se0.insert_I(1,0.7,-0.2,0.09,0.1) # ib=0.7/ lts=-0.2/ rs=0.09 / fs=0.1
    se0.insert_I(tmax-1)

    # run serial communication
    t0,v0,v1,v2,v3=se0.run()

    # plot simulation results
    fig = plt.figure(figsize=(8,4))
    spec = gridspec.GridSpec(ncols=1, nrows=4, figure=fig, hspace=0.1, height_ratios=[1, 1, 1, 1])
    ax0 = fig.add_subplot(spec[0])
    ax1 = fig.add_subplot(spec[1])
    ax2 = fig.add_subplot(spec[2])
    ax3 = fig.add_subplot(spec[3])
    
    ax0.plot(t0, v0)
    ax0.set_xlim(0.5,2.5)
    ax0.set_ylabel("V_ib")
    ax0.set_xticks([])
    ax1.plot(t0, v1, color="red")
    ax1.set_xlim(0.5,2.5)
    ax1.set_ylabel("V_lts")
    ax1.set_xticks([])
    ax2.plot(t0, v2, color="green")
    ax2.set_xlim(0.5,2.5)
    ax2.set_ylabel("V_rs")
    ax2.set_xticks([])
    ax3.plot(t0, v3, color="violet")
    ax3.set_xlim(0.5,2.5)
    ax3.set_ylabel("V_fs")
    ax3.set_xlabel("[s]")
    plt.savefig("demoPQN4.png")
    plt.show()
