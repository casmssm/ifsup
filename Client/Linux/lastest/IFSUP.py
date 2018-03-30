import socket
import sys
import getpass
import hashlib
import binascii
from binascii import unhexlify
import base64
import os
from time import sleep

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET6, socket.SOCK_STREAM, 0)
sock.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY, 0)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

# Bind the socket to the port
server_address = ('::0.0.0.0', 8888)
sock.bind(server_address)

# Listen for incoming connections
sock.listen(1)

while True:
	print >>sys.stderr, 'IFSUP - IFs Universal Printer'
	print >>sys.stderr, 'Linux client ver 0.3 (IPv6 support added)'
	print >>sys.stderr, 'Waiting for printer jobs...'
	# Wait for a connection
	connection, client_address = sock.accept()
	data = connection.recv(512).split("|")
	if data[0] == "auth":
		TCP_IP = data[1]
		TCP_PORT = data[2]
		BUFFER_SIZE = 1024
		print ''
		GETUSER = raw_input("Informe seu Usuario: ")
		GETPASS = getpass.getpass()
		ToMD5 = hashlib.md5()
		ToMD5.update(GETPASS.encode('utf-8'))
		GETPASS = base64.b64encode(unhexlify(ToMD5.hexdigest()))
		MESSAGE = GETUSER + "|{md5}" + GETPASS + "|SEND"
		if TCP_IP.find(":") == -1:
			s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			s.connect((TCP_IP, int(TCP_PORT)))
			s.send(MESSAGE)
			s.close()
		else:
			s = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
			s.connect((TCP_IP, int(TCP_PORT)))
			s.send(MESSAGE)
			s.close()

		try:
			if os.name == "posix":
				os.system('clear')
			else:
				os.system('cls')
		finally:
			A = 1
	if data[0] == "answer":
		if os.name == "posix":
			os.system('clear')
		else:
			os.system('cls')
		print data[3]
		sleep(int(data[2]))
		if os.name == "posix":
			os.system('clear')
		else:
			os.system('cls')

