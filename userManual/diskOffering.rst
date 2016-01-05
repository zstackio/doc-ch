.. _disk offering:

=============
云盘规格（Disk Offering）
=============

.. contents:: `目录`
   :depth: 6

--------
概览（Overview）
--------

云盘规格是云盘的规格描述（specification）, 其中定义了云盘的大小以及如何创建云盘. 云盘规格可以用来创建根云盘（root volumes）和数据云盘（data volumes）.

.. 注意:: 不能通过API创建根云盘; 但是当你用ISO文件配置一个虚拟机的时候, 需要指定一个定义虚拟机根云盘大小以及分配策略（allocator strategy）的云盘规格，这是从云盘规格创建根云盘的唯一方法

.. _disk offering inventory:

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
   * - **diskSize**
     - 单位为字节的云盘大小, 请参见 :ref:`disk size <disk offering size>`
     -
     -
     - 0.6
   * - **state**
     - 请参见 :ref:`state <disk offering state>`
     -
     - - Enabled
       - Disabled
     - 0.6
   * - **type**
     - 保留的域
     -
     - - zstack
     - 0.6
   * - **allocatorStrategy**
     - 请参见 :ref:`allocator strategy <disk offering allocator strategy>`
     -
     - - DefaultPrimaryStorageAllocationStrategy
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

.. _disk offering size:

磁盘大小（Disk Size）
+++++++++

DiskSize定义了云盘的虚拟大小（virtual size）. 正如:ref:`volume <volume>`中提到的那样, 虚拟大小是指云盘声明的大小，也就是云盘完全填满后的在存储系统中所占的大小. 简单的说，虚拟大小就是，你希望云盘有多大.

.. _disk offering state:

可用状态（State）
+++++

云盘规格有两种可用状态:

- **Enabled**:

  启用（Enabled）状态下，允许从云盘规格创建云盘.

- **Disabled**:

  禁用（Disabled）状态下，不允许从云盘规格创建云盘.

.. _disk offering allocator strategy:

分配策略（Allocator Strategy）
++++++++++++++++++

分配策略定义了ZStack怎么选择用于创建新云盘的主存储. ZStack当前版本仅支持寻找满足下列条件主存储的DefaultPrimaryStorageAllocationStrategy策略::

    1. 可用状态为启用（Enabled）
    2. 连接状态为已连接（Connected）
    3. 可用容量（availableCapacity）比云盘规格的diskSize大
    4. 已挂载到云盘将要挂载的虚拟机所在的集群

.. 注意:: 仅当云盘被挂载到虚拟机时，从云盘规格创建的云盘才会在主存储上实例化. 请参见 :ref:`volume status NotInstantiated <volume status>`.

----------
操作（Operations）
----------

创建云盘规格（Create Disk Offering）
====================

用户可以使用CreateDiskOffering创建云盘规格. 例如::

    CreateDiskOffering name=small diskSize=1073741824

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
   * - **diskSize**
     - 以字节为单位的磁盘大小, 请参见 :ref:`size <disk offering size>`
     -
     -
     - 0.6
   * - **allocationStrategy**
     - 请参见 :ref:`allocator strategy <disk offering allocator strategy>`
     - 是
     - - DefaultPrimaryStorageAllocationStrategy
     - 0.6
   * - **type**
     - 保留的域, 请勿使用
     - 是
     -
     - 0.6

改变可用状态（Change State）
============

用户可以使用ChangeDiskOfferingState来改变一个云盘规格的可用状态. 例如::

    ChangeDiskOfferingState uuid=178c662bfcdd4145920682c58ebcbed4 stateEvent=enable

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
   * - **uuid**
     - 云盘规格的uuid
     -
     -
     - 0.6
   * - **stateEvent**
     - 状态触发事件

       - 启用: 改变可用状态为启用（Enabled）
       - 禁用: 改变可用状态为禁用（Disabled）
     -
     - - enable
       - disable
     - 0.6

删除云盘规格（Delete Disk Offering）
====================

用户可以使用DeleteDiskOffering来删除一个云盘规格. 例如::

    DeleteDiskOffering uuid=178c662bfcdd4145920682c58ebcbed4

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
     - 云盘规格的uuid
     -
     -
     - 0.6

查询云盘规格（Query Disk Offering）
===================

用户可以使用QueryDiskOffering来查询云盘规格. 例如::

    QueryDiskOffering diskSize>=10000000

::

    QueryDiskOffering volume.name=data1


原生域查询（Primitive Fields of Query）
+++++++++++++++++++++++++

请参见 :ref:`disk offering inventory <disk offering inventory>`

嵌套和扩展域查询（Nested And Expanded Fields of Query）
+++++++++++++++++++++++++++++++++++

.. list-table::
   :widths: 20 30 40 10
   :header-rows: 1

   * - 域（Field）
     - 清单（Inventory）
     - 描述
     - 起始支持版本
   * - **volume**
     - :ref:`volume inventory <volume inventory>`
     - 从该云盘规格创建出来的所有云盘
     - 0.6

----
标签（Tags）
----

用户可以使用resourceType=DiskOfferingVO在云盘规格上创建用户标签. 例如::

    CreateUserTag tag=smallDisk resourceType=DiskOfferingVO resourceUuid=d6c49e73927d40abbfcf13852dc18367

系统标签（System Tags）
===========

专用主存储（Dedicated Primary Storage）
+++++++++++++++++++++++++

当从云盘规格创建云盘的时候, 用户可以通过系统标签指定从哪个主存储创建云盘.

.. list-table::
   :widths: 20 30 40 10
   :header-rows: 1

   * - 标签
     - 描述
     - 示例
     - 起始支持版本
   * - **primaryStorage::allocator::uuid::{uuid}**
     - | 如果该标签存在, 从该云盘规格创建的云盘会从*uuid*指定的主存储分配;
       | 如果指定的主存储不存在或没有足够的容量，会报告分配失败（allocation failure）.
     - primaryStorage::allocator::uuid::b8398e8b7ff24527a3b81dc4bc64d974
     - 0.6
   * - **primaryStorage::allocator::userTag::{tag}::required**
     - | 如果该标签存在, 从该云盘规格创建的云盘会从带有用户标签*tag*的主存储分配;
       | 如果指定的主存储不存在或没有足够的容量，会报告分配失败（allocation failure）.
     - primaryStorage::allocator::userTag::SSD::required
     - 0.6
   * - **primaryStorage::allocator::userTag::{tag}**
     - | 如果该标签存在, 从该云盘规格创建的云盘会首先尝试从带有用户标签*tag*的主存储分配, 如果找不到带指定标签的主存储或容量不足，ZStack会随机选择一个主存储分配这个云盘.
     - primaryStorage::allocator::userTag::SSD
     - 0.6

如果在云盘规格上有多个上面提到的系统标签存在, 它们的优先顺序是::

    primaryStorage::allocator::uuid::{uuid} > primaryStorage::allocator::userTag::{tag}::required > primaryStorage::allocator::userTag::{tag}
