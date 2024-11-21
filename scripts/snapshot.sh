#!/bin/env bash

read NAME "Please insert the name of the snapshots: "

vagrant snapshot save vm1 $NAME
vagrant snapshot save vm2 $NAME
vagrant snapshot save vm3 $NAME
