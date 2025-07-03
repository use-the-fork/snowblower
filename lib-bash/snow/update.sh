function doSnowUpdate {

    runNix flake update
	doSnowSwitch
	
	exit 0
}
