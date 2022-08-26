from netmiko import ConnectHandler
from pprint import pprint

arista = {
    "device_type": "arista_eos",
    "host": "10.0.0.2",
    "username": "gns3",
    "password": "gns3",
}

command = "show ip int brief"
with ConnectHandler(**arista) as net_connect:
    # Use TextFSM to retrieve structured data
    output = net_connect.send_command(command, use_textfsm=True)

print()
pprint(output)
print()
