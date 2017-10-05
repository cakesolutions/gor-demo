#!/bin/bash
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config
sysctl -w vm.max_map_count=262144
echo "fs.file-max = 100000" >>  /etc/sysctl.conf
echo "* 		 hard 	nofile 		65536" >>  /etc/security/limits.conf
echo ""
