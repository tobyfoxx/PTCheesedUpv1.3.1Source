{
  "$GMObject":"",
  "%Name":"obj_startgate",
  "eventList":[
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":0,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":3,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"","%Name":"","collisionObjectId":{"name":"obj_player","path":"objects/obj_player/obj_player.yy",},"eventNum":0,"eventType":4,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":4,"eventType":7,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":8,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":12,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
  ],
  "managed":true,
  "name":"obj_startgate",
  "overriddenProperties":[],
  "parent":{
    "name":"Doors",
    "path":"folders/Objects/Room Structure/Doors.yy",
  },
  "parentObjectId":null,
  "persistent":false,
  "physicsAngularDamping":0.1,
  "physicsDensity":0.5,
  "physicsFriction":0.2,
  "physicsGroup":0,
  "physicsKinematic":false,
  "physicsLinearDamping":0.1,
  "physicsObject":false,
  "physicsRestitution":0.1,
  "physicsSensor":false,
  "physicsShape":0,
  "physicsShapePoints":[],
  "physicsStartAwake":true,
  "properties":[
    {"$GMObjectProperty":"","%Name":"targetRoom","filters":[],"listItems":[],"multiselect":false,"name":"targetRoom","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"entrance_1","varType":5,},
    {"$GMObjectProperty":"","%Name":"targetDoor","filters":[],"listItems":[],"multiselect":false,"name":"targetDoor","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"A","varType":2,},
    {"$GMObjectProperty":"","%Name":"level","filters":[],"listItems":[],"multiselect":false,"name":"level","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"noone","varType":2,},
    {"$GMObjectProperty":"","%Name":"gateSprite","filters":[],"listItems":[],"multiselect":false,"name":"gateSprite","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"spr_gate_entrance","varType":5,},
    {"$GMObjectProperty":"","%Name":"bgsprite","filters":[],"listItems":[],"multiselect":false,"name":"bgsprite","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"spr_gate_entranceBG","varType":5,},
    {"$GMObjectProperty":"","%Name":"titlecard_sprite","filters":[],"listItems":[],"multiselect":false,"name":"titlecard_sprite","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"spr_titlecards","varType":5,},
    {"$GMObjectProperty":"","%Name":"titlecard_index","filters":[],"listItems":[],"multiselect":false,"name":"titlecard_index","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"","%Name":"title_sprite","filters":[],"listItems":[],"multiselect":false,"name":"title_sprite","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"spr_titlecards_title","varType":5,},
    {"$GMObjectProperty":"","%Name":"title_index","filters":[],"listItems":[],"multiselect":false,"name":"title_index","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"","%Name":"title_music","filters":[],"listItems":[],"multiselect":false,"name":"title_music","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"event:/music/w1/entrancetitle","varType":2,},
    {"$GMObjectProperty":"","%Name":"allow_modifier","filters":[],"listItems":[],"multiselect":false,"name":"allow_modifier","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"True","varType":3,},
    {"$GMObjectProperty":"","%Name":"show_titlecard","filters":[],"listItems":[],"multiselect":false,"name":"show_titlecard","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"True","varType":3,},
    {"$GMObjectProperty":"","%Name":"door_index","filters":[],"listItems":[],"multiselect":false,"name":"door_index","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"-1","varType":0,},
  ],
  "resourceType":"GMObject",
  "resourceVersion":"2.0",
  "solid":false,
  "spriteId":{
    "name":"spr_gate_entrance",
    "path":"sprites/spr_gate_entrance/spr_gate_entrance.yy",
  },
  "spriteMaskId":{
    "name":"spr_gate_entrance",
    "path":"sprites/spr_gate_entrance/spr_gate_entrance.yy",
  },
  "visible":true,
}