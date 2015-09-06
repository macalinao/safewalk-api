import json

file = open('data/datagen_raw.txt').read();
rows = file.split('\n')

ret = []
for row in rows:
    split = row.split('|')
    if len(split) != 4: continue
    ret.append({
        'longitude': split[0],
        'latitude': split[1],
        'title': split[2],
        'type': split[3],
    })

json.dump(ret, open('data/datagen_res.json', 'w'))
