#!/usr/bin/env nu

use std assert

def main [
    --instance: string
    --world: string
    --computer-id: string
] {
    
    let schema = open deploy_schema.yaml
    let instance = ($schema | get instances | get $instance)
    let instance_folder = ($instance | get minecraft_folder)
    let world_folder = ($instance_folder | path join saves $world)
    assert ($world_folder | path exists)

    let computer_folder = ($world_folder | path join computercraft computer $computer_id | path expand)
    mkdir $computer_folder
    print $computer_folder

    haxe build.hxml
    cp lua/main.lua ($computer_folder | path join startup.lua)

}
