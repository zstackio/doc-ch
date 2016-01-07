.. _instance offering:

=================
计算规格（Instance Offering）
=================

.. contents:: `目录`
   :depth: 6

--------
概览（Overview）
--------

计算规格定义了虚拟机的内存，CPU和主机分配算法（allocation algorithm）的规范（specification）; 它定义了虚拟机的计算资源容量（volume of computing
resource).

.. _instance offering inventory:

---------
清单（Inventory）
---------

属性（Properties）
==========

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
   * - **cpuNum**
     - VCPU数目, 请参见 :ref:`CPU capacity <instance offering cpu capacity>`
     -
     -
     - 0.6
   * - **cpuSpeed**
     - VCPU速度, 请参见 :ref:`CPU capacity <instance offering cpu capacity>`
     -
     -
     - 0.6
   * - **memorySize**
     - 内存大小, 单位是字节
     -
     -
     - 0.6
   * - **type**
     - 计算规格类型, 默认为UserVm, 请参见 :ref:`type <instance offering type>`
     - 是
     - - UserVm
       - VirtualRouter
     - 0.6
   * - **allocatorStrategy**
     - 主机分配策略, 请参见 :ref:`allocator strategy <instance offering allocator strategy>`
     -
     - - DefaultHostAllocatorStrategy
       - DesignatedHostAllocatorStrategy
     - 0.6
   * - **state**
     - 请参见 :ref:`state <instance offering state>`
     -
     - - Enabled
       - Disabled
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

.. _instance offering cpu capacity:

CPU容量（CPU Capacity）
++++++++++++

计算规格使用cpuNum和cpuSpeed来定义虚拟机的CPU容量. cpuNum直接代表了虚拟机所拥有的VCPU数量; cpuSpeed有些特别; 由于虚拟机的VCPU总是和主机上的物理CPU有相同的频率, 这里的cpuSpeed实际上是指在虚拟机管理程序中的VCPU权重（weight）. 虚拟机管理程序不同，对于cpuSpeed的使用和实现也不同.

KVM CPU速度（KVM CPU Speed）
-------------

在KVM中, ZStack会使用'cpuSpeed * cpuNum'的结果来设置libvirt的虚拟机XML配置::

  <cputune>
    <shares>128</shares>
  </cputune>

  shares = cpuNum * cpuSpeed

.. _instance offering type:

类型（Type）
++++

计算规格的类型; 当前有两种计算规格类型:

- **UserVm**: 创建用户虚拟机所使用的计算规格.

- **VirtualRouter**: 创建虚拟路由（virtual router）虚拟机所使用的计算规格; 请参见 :ref:`virtual router <virtual router>`.

.. _instance offering allocator strategy:

分配策略（Allocator Strategy）
++++++++++++++++++

分配策略定义了选择用于创建虚拟机的主机的算法.

DefaultHostAllocatorStrategy
----------------------------

DefaultHostAllocatorStrategy使用下面的算法:

输入参数（Input Parameters）
****************
.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - 名字
     - 描述
   * - **image**
     - 用于创建虚拟机的镜像
   * - **L3 network**
     - 虚拟机的网卡将连接到的L3网络
   * - **instance offering**
     - 计算规格
   * - **tags**
     - 用于主机分配的标签

算法（Algorithm）
*********

::

    l2_networks = get_parent_l2_networks(l3_networks)
    host_set1 = find_hosts_in_cluster_that_have_attached_to_l2_networks()
    check_if_backup_storage_having_image_have_attached_to_zone_of_hosts(host_set1)
    host_set2 = remove_hosts_not_having_state_Enabled_and_status_Connected(host_set1)
    host_set3 = remove_hosts_not_having_capacity_required_by_instance_offering(host_set2)
    primary_storage = find_Enabled_Connected_primary_storage_having_enough_capacity_for_root_volume_and_attached_to_clusters_of_hosts(image, host_set3)
    host_set4 = remove_hosts_that_cannot_access_primary_storage(host_set3)
    host_set5 = remove_avoided_hosts(host_set4)
    host_set6 = call_tag_plugin(tags, host_set5)

    return randomly_pick_one_host(host_set6)


.. _DesignatedHostAllocatorStrategy:

DesignatedHostAllocatorStrategy
-------------------------------

DesignatedHostAllocatorStrategy使用下面的算法:

输入参数（Input Parameters）
****************
.. list-table::
   :widths: 30 60 10
   :header-rows: 1

   * - 名字
     - 描述
     - 可选的
   * - **image**
     - 用于创建虚拟机的镜像
     -
   * - **L3 network**
     - 虚拟机的网卡将连接到的L3网络
     -
   * - **instance offering**
     - 计算规格
     -
   * - **tags**
     - 用于主机分配的标签
     -
   * - **zone**
     - 虚拟机想要运行的区域
     - 是
   * - **cluster**
     - 虚拟机想要运行的集群
     - 是
   * - **host**
     - 虚拟机想要运行的主机
     - 是

算法（Algorithm）
*********

::

    l2_networks = get_parent_l2_networks(l3_networks)
    host_set1 = find_hosts_in_cluster_that_have_attached_to_l2_networks()
    check_if_backup_storage_having_image_have_attached_to_zone_of_hosts(host_set1)

    if host is not null:
       host_set2 = list(find_host_in_host_set1(host))
    else if cluster is not null:
       host_set2 = find_host_in_cluster_and_host_set1(cluster)
    else if zone is not null:
       host_set2 = find_host_in_zone_and_host_set1(zone)

    host_set3 = remove_hosts_not_having_state_Enabled_and_status_Connected(host_set2)
    host_set4 = remove_hosts_not_having_capacity_required_by_instance_offering(host_set3)
    primary_storage = find_Enabled_Connected_primary_storage_having_enough_capacity_for_root_volume_and_attached_to_clusters_of_hosts(image, host_set4)
    host_set5 = remove_hosts_that_cannot_access_primary_storage(host_set4)
    host_set6 = remove_avoided_hosts(host_set5)
    host_set7 = call_tag_plugin(tags, host_set6)

    return randomly_pick_one_host(host_set7)


.. 注意:: DesignatedHostAllocatorStrategy在计算规格中有一些特别需要指出的地方; 当在:ref:`CreateVmInstance <CreateVmInstance>`指定了zoneUuid或clusterUuid或hostUuid, DesignatedHostAllocatorStrategy将自动覆盖计算规格的现有策略.

.. _instance offering state:

可用状态（State）
+++++

计算规格有两种可用状态:

- **Enabled**:

  启用（Enabled）状态下，允许从计算规格创建虚拟机

- **Disabled**:

  禁用（Disabled）状态下，不允许从计算规格创建虚拟机

----------
操作（Operations）
----------

.. _CreateInstanceOffering:

创建计算规格（Create Instance Offering）
========================

用户可以使用CreateInstanceOffering来创建一个计算规格. 例如::

    CreateInstanceOffering name=small cpuNum=1 cpuSpeed=1000 memorySize=1073741824

参数（Parameters）
++++++++++

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
   * - **cpuNum**
     - VCPU的数量, 请参见 :ref:`CPU capacity <instance offering cpu capacity>`
     -
     -
     - 0.6
   * - **cpuSpeed**
     - VCPU的熟读, 请参见 :ref:`CPU capacity <instance offering cpu capacity>`
     -
     -
     - 0.6
   * - **memorySize**
     - 内存大小, 单位是字节
     -
     -
     - 0.6
   * - **type**
     - 类型, 默认为UserVm, 请参见 :ref:`type <instance offering type>`
     - 是
     - - UserVm
       - VirtualRouter
     - 0.6

.. _DeleteInstanceOffering:

删除计算规格（Delete Instance Offering）
========================

用户可以使用DeleteInstanceOffering来删除一个计算规格. 例如::

    DeleteInstanceOffering uuid=1164a094fea34f1e8265c802a8048bae


参数（Parameters）
++++++++++

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
     - 计算规格的uuid
     -
     -
     - 0.6

改变可用状态（Change State）
============

用户可以使用ChangeInstanceOfferingState来改变一个计算规格的可用状态. 例如::

    ChangeInstanceOfferingState uuid=1164a094fea34f1e8265c802a8048bae stateEvent=enable

参数（Parameters）
++++++++++

.. list-table::
   :widths: 20 40 10 20 10
   :header-rows: 1

   * - 名字
     - 描述
     - 可选的
     - 可选的参数值
     - 起始支持版本
   * - **stateEvent**
     - 状态触发事件

       - 启用: 改变可用状态为启用（Enabled）
       - 禁用: 改变可用状态为禁用（Disabled）
     -
     - - enable
       - disable
     - 0.6
   * - **uuid**
     - 计算规格的uuid
     -
     -
     - 0.6

查询计算规格（Query Instance Offering）
=======================

用户可以使用QueryInstanceOffering来查询一个计算规格. 例如::

    QueryInstanceOffering cpuSpeed=512 cpuNum>2

::

    QueryInstanceOffering vmInstance.state=Stopped


原生域查询（Primitive Fields of Query）
+++++++++++++++++++++++++

请参见 :ref:`instance offering inventory <instance offering inventory>`

嵌套和扩展域查询（Nested and Expanded Fields of Query)
+++++++++++++++++++++++++++++++++++

.. list-table::
   :widths: 20 30 40 10
   :header-rows: 1

   * - 域（Field）
     - 清单（Inventory）
     - 描述
     - 起始支持版本
   * - **vmInstance**
     - :ref:`VM inventory <vm inventory>`
     - 从该计算规格创建的所有虚拟机
     - 0.6

----
标签（Tags）
----

用户可以使用resourceType=InstanceOfferingVO在计算规格上创建用户标签. 例如::

    CreateUserTag resourceType=InstanceOfferingVO tag=web-server-offering resourceUuid=45f909969ce24865b1bbca4adb66710a

系统标签（System Tags）
===========

专用主存储（Dedicated Primary Storage）
+++++++++++++++++++++++++

当创建虚拟机的时候, 用户可以通过系统标签指定从哪个主存储创建根云盘.

.. list-table::
   :widths: 20 30 40 10
   :header-rows: 1

   * - 标签
     - 描述
     - 示例
     - 起始支持版本
   * - **primaryStorage::allocator::uuid::{uuid}**
     - | 如果该标签存在, 虚拟机的根云盘会从*uuid*指定的主存储分配;
       | 如果指定的主存储不存在或没有足够的容量，会报告分配失败（allocation failure）.
     - primaryStorage::allocator::uuid::b8398e8b7ff24527a3b81dc4bc64d974
     - 0.6
   * - **primaryStorage::allocator::userTag::{tag}::required**
     - | 如果该标签存在, 虚拟机的根云盘会从带有用户标签*tag*的主存储分配;
       | 如果指定的主存储不存在或没有足够的容量，会报告分配失败（allocation failure）
     - primaryStorage::allocator::userTag::SSD::required
     - 0.6
   * - **primaryStorage::allocator::userTag::{tag}**
     - | 如果该标签存在, 虚拟机的根云盘会首相尝试从带有用户标签*tag*的主存储分配, 如果找不到带指定标签的主存储或容量不足，ZStack会随机选择一个主存储分配这个根云盘;.
     - primaryStorage::allocator::userTag::SSD
     - 0.6

如果在计算规格上有多个上面提到的系统标签存在, 它们的优先顺序是::

    primaryStorage::allocator::uuid::{uuid} > primaryStorage::allocator::userTag::{tag}::required > primaryStorage::allocator::userTag::{tag}
