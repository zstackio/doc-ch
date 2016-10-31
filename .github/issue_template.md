### 描述
添加主机（Add Host）
不同虚拟机管理程序添加主机的命令不同.

### API
`org.zstack.kvm.APIAddKVMHostMsg`

### 举例(Example)

管理员可以使用AddKVMHost来添加一个KVM主机. 例如: 

> AddKVMHost clusterUuid=8524072a4274403892bcc5b1972c2576 managementIp=192.168.10.10 name=kvm1 username=root password=passwo

### 参数（Parameters）
     
| 名字| 描述 | 可选的 | 可选的参数 | 起始支持版本 |
| --- |:-------:| -----:|
| name | 物理机 |  
| resourceUuid | 资源的uuid |是 |
| description | 
| clusterUuid |
| managementIp |
| username |
| password |

| 名字        | 描述           | 可选的参数 | 起始支持版本 |
| ------------- |:-------------:| -----:|
| name     | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |
| resourceUuid | 资源的uuid |是 |
| description | 
| clusterUuid |
| managementIp |
| username |
| password |

### 备注
* **KVM证书（KVM Credentials）**
ZStack使用一个叫做kvmagent的Python代理(agent)来管理KVM主机. ZStack使用`Ansible<http://www.ansible.com/home>`_来配置目标Linux操作系统并部署kvmagents，以实现完全的自动化; 
* **备注2**
