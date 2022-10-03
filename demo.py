import serial
import threading
import time
import matplotlib.pyplot as plt
from matplotlib import gridspec

# please specify the port name
PORT_NAME = "COM4"

# Parameters for serial communication
# If you change these parameters, you must also change the vhdl code on the FPGA
BAUD_RATE = 1000000 # baud rate
NUM_DATA = 3        # a single signal (18-bits) is sent in 3 bytes
NUM_SIGNAL = 2      # two signals (v and I) are received
NUM_BIT = 18        # signals are represented by fixed-point 18 bits
DT = 0.0001         # time step of the simulation [s]
LF = 10             # line feed
SEND_TW = 0.1       # interval between data transmissions
REST_TIME = 1       # additional receive time

# global flag for controlling threads
receiver_stop_flag=0
receiver_processing_end_flag=0

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
    # a single packet is composed of following seven byte data
    # v0, v1, v2, I0, I1, I2 , LF
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
    print("start processing")
    list_v=[]
    list_I=[]
    t0=[]
    c0=0
    while received_data[0]!=10:
        received_data.pop(0)
    received_data.pop(0)
    for i in range(int(len(received_data)/(NUM_DATA*NUM_SIGNAL+1))):
        list_v.append(received_data[i*(NUM_DATA*NUM_SIGNAL+1):i*(NUM_DATA*NUM_SIGNAL+1)+NUM_DATA])
        list_I.append(received_data[i*(NUM_DATA*NUM_SIGNAL+1)+NUM_DATA:i*(NUM_DATA*NUM_SIGNAL+1)+NUM_DATA*2])
        t0.append(c0*DT)
        c0=c0+1
    global gt,gv,gI
    gt=t0
    gv=[]
    gI=[]
    for i in range(len(list_v)):
        gv.append(decoder(list_v[i]))
        gI.append(decoder(list_I[i]))
    global receiver_processing_end_flag
    receiver_processing_end_flag=1

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
    # when I is to be changed, the packet contains the following four byte data
    # I0, I1, I2 , LF
    # where Ix are used to decode I that is a 18-bit signal
class send_data:
    def __init__(self,tmax):
        self.I_list=[]
        self.packet_list=[]
        self.tmax=tmax
    def set_I(self,t0,I0):
        self.I_list.append([t0,I0])
    def generate_packet_list(self):
        c0=0
        packet=[]
        for i in range(int((self.tmax+1)/DT)):
            for j, x in enumerate(self.I_list):
                if i==int(x[0]/DT):
                    print("inserted", i*DT, "[s], I=", x[1])
                    packet.extend(encode_I(x[1]))
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
    def insert_I(self,t0,I0):
        self.d0.set_I(t0,I0)
    def run(self):
        self.d0.generate_packet_list()
        ser = serial.Serial(PORT_NAME, baudrate=BAUD_RATE, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE)
        ser.set_buffer_size(rx_size=12800, tx_size=12800)
        thread1 = threading.Thread(target=receiver, args=(ser,))
        thread1.start()
        t1=time.time()
        t2=time.time()
        k0=0
        while t2-t1<self.tmax:
            ser.write(self.d0.packet_get())
            k0+=1
            t2=time.time()
            time.sleep(SEND_TW*k0-(t2-t1))
        global receiver_stop_flag
        time.sleep(REST_TIME)
        receiver_stop_flag=1
        global receiver_processing_end_flag
        while receiver_processing_end_flag==0:
            pass
        ser.close()
        return gt,gv,gI

if __name__ == "__main__":

    # length of simulation [s]
    tmax=3

    # set serial communication
    se0=serial_test(tmax)

    # set stimulus input
       # arg0: time [s]
       # arg1: magnitude of I
    se0.insert_I(0,0)
    se0.insert_I(1,0.09)
    se0.insert_I(2,0)

    # run serial communication
    t0,v0,I0=se0.run()

    # plot simulation results
    fig = plt.figure(figsize=(8,4))
    spec = gridspec.GridSpec(ncols=1, nrows=2, figure=fig, hspace=0.1, height_ratios=[4, 1])
    ax0 = fig.add_subplot(spec[0])
    ax1 = fig.add_subplot(spec[1])
    ax0.plot(t0, v0)
    ax0.set_xlim(0.5,2.5)
    ax0.set_ylabel("v")
    ax0.set_xticks([])
    ax1.plot(t0, I0, color="black")
    ax1.set_xlim(0.5,2.5)
    ax1.set_xlabel("[s]")
    ax1.set_ylabel("I")
    plt.savefig("demo.png")
    plt.show()
