### 描述
添加主机（Add Host）
不同虚拟机管理程序添加主机的命令不同.

### API
`org.zstack.kvm.APIAddKVMHostMsg`

### 举例(Example)

管理员可以使用AddKVMHost来添加一个KVM主机. 例如: 

```
AddKVMHost clusterUuid=f995b4e3593c45fabeabd92185d33f91 managementIp=172.20.12.111 name=Host1 username=root password=password
```
返回结果：
```
{
    "inventory": {
        "availableCpuCapacity": 40,
        "availableMemoryCapacity": 8203108352,
        "clusterUuid": "f995b4e3593c45fabeabd92185d33f91",
        "createDate": "Nov 2, 2016 11:22:15 PM",
        "hypervisorType": "KVM",
        "lastOpDate": "Nov 2, 2016 11:22:29 PM",
        "managementIp": "172.20.12.111",
        "name": "Host1",
        "sshPort": 22,
        "state": "Enabled",
        "status": "Connected",
        "totalCpuCapacity": 40,
        "totalMemoryCapacity": 8203108352,
        "username": "root",
        "uuid": "62eea75fc6204a439d3d1dd7b1946bc5",
        "zoneUuid": "d75c4578be6145fbb1a1f5bfc4b43e95"
    },
    "success": true
}
```


### 参数（Parameters）
     
| 名字 | 描述 | 可选的参数 | 起始支持版本 |
| ---- | --- | --- | --- |
| name | | | |
| resourceUuid | 资源的uuid |是 | |
| description | | | 0.6|
| clusterUuid | | | |
| managementIp | | | |
| username | | | | 
| password |||| 

### 备注
* **KVM证书（KVM Credentials）**
ZStack使用一个叫做kvmagent的Python代理(agent)来管理KVM主机. ZStack使用`Ansible<http://www.ansible.com/home>`_来配置目标Linux操作系统并部署kvmagents，以实现完全的自动化; 

* **备注2**



