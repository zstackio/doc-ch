.. _eip:

======================================
弹性IP地址（Elastic IP Address）
======================================

.. contents:: `目录`
   :depth: 6

--------------------
概览（Overview）
--------------------

弹性IP地址(EIP) 提供了外部网络访问SNAT后面的L3网络的途径. EIP基于网络地址转换(NAT), 将一个网络（通常是公有网络）的IP地址转换成另一个网络（通常是一个私有网络）的IP地址; 就像它的名字一样, EIP可以动态的挂载到虚拟机或从一个虚拟机上卸载.

.. image:: eip1.png
   :align: center

.. _eip inventory:

----------------------
清单（Inventory）
----------------------

属性（Properties）
======================

.. list-table::
   :widths: 20 40 10 20 10
   :header-rows: 1

   * - 名字
     - 描述
     - 可选的
     - 可选的参数值
     - 起始支持版本
   * - **uuid**
     - 请参见 :ref:`resource properties`
     -
     -
     - 0.6
   * - **name**
     - 请参见 :ref:`resource properties`
     -
     -
     - 0.6
   * - **description**
     - 请参见 :ref:`resource properties`
     - 是
     -
     - 0.6
   * - **vmNicUuid**
     - EIP绑定的虚拟机网卡的uuid
     - true
     -
     - 0.6
   * - **vipUuid**
     - VIP的uuid
     -
     -
     - 0.6
   * - **state**
     - EIP的可用状态, 当前版本中未实现
     -
     - - Enabled
       - Disabled
     - 0.6
   * - **vipIp**
     - VIP的IP地址
     -
     -
     - 0.6
   * - **guestIp**
     - 虚拟机网卡的IP
     - 是
     -
     - 0.6
   * - **createDate**
     - 请参见 :ref:`resource properties`
     -
     -
     - 0.6
   * - **lastOpDate**
     - 请参见 :ref:`resource properties`
     -
     -
     - 0.6

示例
=======

::

        {
            "createDate": "Nov 28, 2015 6:52:14 PM",
            "guestIp": "10.0.0.170",
            "lastOpDate": "Nov 28, 2015 6:52:14 PM",
            "name": "eip-vlan10",
            "state": "Enabled",
            "uuid": "76b9231c94cd4a3aac497200bb26a643",
            "vipIp": "192.168.0.189",
            "vipUuid": "429106d5a63a4995911c2c5f14299b85",
            "vmNicUuid": "70cac1fd0c2f4940ba32645e09d3e22f"
        }

-----------------------
操作（Operations）
-----------------------

创建EIP（Create EIP）
=========================

用户可以使用CreateEip来创建一个EIP. 例如::

      CreateEip name=eip1 vipUuid=429106d5a63a4995911c2c5f14299b85 vmNicUuid=70cac1fd0c2f4940ba32645e09d3e22f

参数（Parameters）
++++++++++++++++++++++

.. list-table::
   :widths: 20 40 10 20 10
   :header-rows: 1

   * - 名字
     - 描述
     - 可选的
     - 可选的参数值
     - 起始支持版本
   * - **name**
     - 资源的名字, 请参见 :ref:`resource properties`
     -
     -
     - 0.6
   * - **resourceUuid**
     - 资源的uuid, 请参见 :ref:`create resource`
     - 是
     -
     - 0.6
   * - **description**
     - 资源的描述, 请参见 :ref:`resource properties`
     - 是
     -
     - 0.6
   * - **vipUuid**
     - VIP的uuid
     -
     -
     - 0.6
   * - **vmNicUuid**
     - 虚拟机网卡的uuid; 如果忽略该参数, EIP会被创建，但不会挂载到任何虚拟机网卡.
     - true
     -
     - 0.6

删除EIP（Delete EIP）
==========================

用户可以使用DeleteEip来删除一个EIP. 例如::

    DeleteEip uuid=76b9231c94cd4a3aac497200bb26a643

被删除后, 绑定到该EIP的VIP会被回收使用在其他网络服务中.

参数（Parameters）
++++++++++++++++++++++

.. list-table::
   :widths: 20 40 10 20 10
   :header-rows: 1

   * - 名字
     - 描述
     - 可选的
     - 可选的参数值
     - 起始支持版本
   * - **deleteMode**
     - 请参见 :ref:`delete resource`
     - 是
     - - Permissive
       - Enforcing
     - 0.6
   * - **uuid**
     - EIP的uuid
     -
     -
     - 0.6

挂载EIP（Attach EIP）
==========================

用户可以使用AttachEip来挂载一个EIP到一个虚拟机的网卡上. 例如::

    AttachEip eipUuid=76b9231c94cd4a3aac497200bb26a643 vmNicUuid=70cac1fd0c2f4940ba32645e09d3e22f


参数（Parameters）
++++++++++++++++++++++

.. list-table::
   :widths: 20 40 10 20 10
   :header-rows: 1

   * - 名字
     - 描述
     - 可选的
     - 可选的参数值
     - 起始支持版本
   * - **eipUuid**
     - EIP的uuid
     -
     -
     - 0.6
   * - **vmNicUuid**
     - 虚拟机网卡的uuid
     -
     -
     - 0.6


卸载EIP（Detach EIP）
==========================

用户可以使用DetachEip来从虚拟机的网卡卸载一个EIP. 例如::

    DetachEip uuid=76b9231c94cd4a3aac497200bb26a643


参数（Parameters）
++++++++++++++++++++++

.. list-table::
   :widths: 20 40 10 20 10
   :header-rows: 1

   * - 名字
     - 描述
     - 可选的
     - 可选的参数值
     - 起始支持版本
   * - **uuid**
     - EIP的uuid
     -
     -
     - 0.6

查询EIP（Query EIP）
=========================

用户可以使用QueryEip来查询EIP. 例如::

    QueryEip vipIp=191.13.10.2

::

    QueryEip vmNic.vmInstance.state=Running


原生域（Primitive Fields）
+++++++++++++++++++++++++++++++

请参见 :ref:`EIP inventory <eip inventory>`

嵌套和扩展域（Nested And Expanded Fields）
+++++++++++++++++++++++++++++++++++++++++++++++++++

.. list-table::
   :widths: 20 30 40 10
   :header-rows: 1

   * - 域（Field）
     - 清单（Inventory）
     - 描述
     - 起始支持版本
   * - **vip**
     - :ref:`VIP inventory <vip inventory>`
     - 改EIP绑定的VIP
     - 0.6
   * - **vmNic**
     - :ref:`VM nic inventory <vm nic inventory>`
     - 该EIP绑定的虚拟机网卡
     - 0.6

----------------------------------------
全局配置（Global Configurations）
----------------------------------------

.. _eip.snatInboundTraffic:

snatInboundTraffic
==================

.. list-table::
   :widths: 20 30 20 30
   :header-rows: 1

   * - 名字
     - 类别
     - 默认值
     - 可选的参数值
   * - **snatInboundTraffic**
     - eip
     - false
     - - true
       - false

该设置决定是否对EIP的流入流量使用源NAT. 如果设置为true, 到达eip.guestIp的流量会使用eip.vipIp作为源IP（source IP）; 这在一个虚拟机上挂载了多个EIP的时候比较有用; 它会强制虚拟机通过EIP回复流入的流量至数据包的来源, 而不是通过默认路由来回复.

-----------------
标签（Tags）
-----------------

用户可以使用resourceType=EipVO来在EIP上创建一个用户标签. 例如::

    CreateUserTag resourceType=EipVO tag=web-public-ip resourceUuid=29fa6c2830c441aaa388d8165b80c24c
