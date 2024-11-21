#!/bin/env python3

import swiftclient
# Important: create a user and then a subuser. The "user" is also the so called "account" for S3. The subuser is only needed for the swift api.
user = 'swiftclientuser:swiftclientsubuser'
key = 'hCcKU67qvmEMKLJ55Z8ZoDySWAvNrqCvF12VZ05B'

conn = swiftclient.Connection(
        user=user,
        key=key,
        authurl='http://192.168.121.115:8080/auth',
)

# Create a container (bucket)
container_name = 'my-new-container'
conn.put_container(container_name)

# Create an object 
with open('hello.txt', 'r') as hello_file:
        conn.put_object(container_name, 'hello.txt',
                                        contents= hello_file.read(),
                                        content_type='text/plain')

# List owned containers
for container in conn.get_account()[1]:
        print(container['name'])

# List containers content
for data in conn.get_container(container_name)[1]:
        print('{0}\t{1}\t{2}'.format(data['name'], data['bytes'], data['last_modified']))

# Retrieve an object
# obj_tuple = conn.get_object(container_name, 'hello.txt')
# with open('my_hello.txt', 'w') as my_hello:
#        my_hello.write(obj_tuple[1])

# Delete Object
# conn.delete_object(container_name, 'hello.txt')

# Delete Container
# conn.delete_container(container_name)