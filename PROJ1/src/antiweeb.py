from fbchat import Client
from fbchat.models import *
import time

client = Client("henrijsantos99@gmail.com", "teste123")
print("Own id: {}".format(client.uid))

client.sendMessage("Kaze no you ni", thread_id=1743553575716002, thread_type=ThreadType.GROUP)
time.sleep(2)
client.sendMessage("Tsukimihara wo", thread_id=1743553575716002, thread_type=ThreadType.GROUP)
time.sleep(2)
client.sendMessage("Padoru padoru!!", thread_id=1743553575716002, thread_type=ThreadType.GROUP)
time.sleep(600)

i = 1;
while i < 100:
        client.sendMessage("Hashire sore yo", thread_id=1743553575716002, thread_type=ThreadType.GROUP)
        time.sleep(2)
        client.sendMessage("Kaze no you ni", thread_id=1743553575716002, thread_type=ThreadType.GROUP)
        time.sleep(2)
        client.sendMessage("Tsukimihara wo", thread_id=1743553575716002, thread_type=ThreadType.GROUP)
        time.sleep(2)
        client.sendMessage("Padoru padoru!!", thread_id=1743553575716002, thread_type=ThreadType.GROUP)
        time.sleep(600)
        i += 1

client.logout()