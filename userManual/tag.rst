.. _tag:

====
标签（Tags）
====

.. contents:: `目录`
   :depth: 6

--------
概览
--------

ZStack提供两类标签来帮助用户和插件管理资源， 引入额外的资源属性， 以及指挥ZStack执行特殊的业务逻辑. 对于标签的架构设计请参见`The Tag System <http://zstack.org/blog/tag.html>`_.

---------
用户标签（User Tags）
---------

用户可以在他们所拥有的资源上创建用户标签，这对于管理相似资源的聚集特别有用;
例如, 用户可以为作为网页服务器(Web Server)的虚拟机设置一个标签'web'::

    CreateUserTag resourceType=VmInstanceVO resourceUuid=613af3fe005914c1643a15c36fd578c6 tag=web

::

    CreateUserTag resourceType=VmInstanceVO resourceUuid=5eb55c39db015c1782c7d814900a9609 tag=web

::

    CreateUserTag resourceType=VmInstanceVO resourceUuid=0cd1ef8c9b9e0ba82e0cc9cc17226a26 tag=web

之后, 可以通过:ref:`Query API with tags <query with tags>`来获取这些虚拟机::

    QueryVmInstance __userTag__=web


用户也可以通过用户标签和系统标签（system tags）合作来改变ZStack的业务逻辑; 例如, 用户可能想在所有作为网页服务器的虚拟机上在一个特定的通过SSD提高IO性能的主存储上创建他们的根存储卷（root volumes）; 要达到这个目的,
用户可以在主存储上创建一个用户标签'forWebTierVM'::

    CreateUserTag tag=forWebTierVM resourceType=PrimaryStorageVO resourceUuid=6572ce44c3f6422d8063b0fb262cbc62

然后在计算方案(instance offering)上创建一个系统标签::

    CreateSystemTag tag=primaryStorage::allocator::userTag::forWebTierVM resourceType=InstanceOfferingVO resourceUuid=8f69ef6c2c444cdf8c019fa0969d56a5

这样, 当用户创建通过计算方案[uuid:8f69ef6c2c444cdf8c019fa0969d56a5]创建虚拟机的, ZStack会保证虚拟机的根存储卷都会被创建在拥有用户标签'forWebTierVM'的主存储上，
在这个例子中, 这个主存储的UUID为6572ce44c3f6422d8063b0fb262cbc62.

-----------
系统标签（System Tags）
-----------

系统标签相比用户标签有更广泛的用途; 就像上一节中的例子一样，用户可以使用它们来指导ZStack执行特殊的业务逻辑.
扩展ZStack功能的插件（Plugins）可以通过使用系统标签来引入额外的资源属性, 或记录和资源紧密相关的元数据.

例如, 要想在KVM主机上实施在线迁移（live migration）或者在线镜像（live snapshot）, ZStack需要知道KVM主机的libvirt版本和QEMU版本，这些信息都是元数据
因此ZStack将他们作为主机的系统标签存储起来. 例如, 管理员可以通过下面的命令查看一个KVM主机的系统标签::

    QuerySystemTag fields=tag resourceUuid=d07066c4de02404a948772e131139eb4

*d07066c4de02404a948772e131139eb4*是某个云主机的UUID, 查询结果为::

    {
      "inventories": [
          {
              "tag": "capability:liveSnapshot"
          },
          {
              "tag": "qemu-img::version::2.0.0"
          },
          {
              "tag": "os::version::14.04"
          },
          {
              "tag": "libvirt::version::1.2.2"
          },
          {
              "tag": "os::release::trusty"
          },
          {
              "tag": "os::distribution::Ubuntu"
          }
      ],
      "success": true
    }

这一类的系统标签, 被称为内部系统标签（inherent system tags）; 内部系统标签只能被ZStack的服务（services）或插件（plugins）创建, 并且不能被DeleteTag API删除.

为了增加新的功能, 插件通常需要为一个资源添加新的属性; 虽然插件不能通过改变一个资源的数据库模式（database schema）来增加一个新的列（column）
, 但它可以为一个资源创建作为系统标签的新属性. 例如, 当创建一个虚拟机时, 用户可以为云主机某L3网络上的网卡绑定一个可以通过网络访问的机器名（hostname）::

    CreateVmInstance name=testTag systemTags=hostname::web-server-1 l3NetworkUuids=6572ce44c3f6422d8063b0fb262cbc62 instanceOfferingUuid=04b5419ca3134885be90a48e372d3895 imageUuid=f1205825ec405cd3f2d259730d47d1d8

这个机器名被实现为一个系统标签; 如果你查看 :ref:`VM inventory in chapter 'Virtual Machine' <vm inventory>`, 那里没有叫做'hostname'的属性; 然而, 你可以在
虚拟机的系统标签中发现它::

    QuerySystemTag fields=tag,uuid resourceUuid=76e119bf9e16461aaf3d1b47c645c7b7

::

    {
      "inventories": [
          {
              "tag": "hostname::web-server-1",
              "uuid": "596070a6276746edbf0f54ef721f654e"
          }
      ],
      "success": true
    }

这类系统标签就是非内部的（non-inherent）, 用户可以通过DeleteTag删除它; 例如, 如果用户想把一个之前的虚拟机的机器名更改为
'web-server-nginx', 可以这样做::


    DeleteTag uuid=596070a6276746edbf0f54ef721f654e

::

    CreateSystemTag resourceType=VmInstanceVO tag=hostname::web-server-nginx resourceUuid=76e119bf9e16461aaf3d1b47c645c7b7

停止和启动虚拟机之后, 虚拟机中的系统（guest operating system）会接受到'web-server-nginx'作为新的机器名.

.. 注意:: 系统标签是被ZStack的服务和插件预定义的; 用户不能再一个资源上创建不存在的系统标签.
          你可以在每个资源的对应"标签"章节中找到资源的所有系统标签.

---------------
命名约定（Name Convention）
---------------

用户标签和系统标签最多都只能有2048个字符.

对于用户标签, 没有强制的命名约定, 但推荐使用可读的有意义的字符串.

对于系统标签, 和ZStack中服务和插件定义的一样, 他们使用 *::* 作为分隔符（delimiters）.

.. _tag resource type:

-------------
资源类型（Resource Type）
-------------

当创建一个标签时, 用户必须制定标签所关联的资源类型(resource type). 在当前版本中, 资源类型被列在下表中:

.. list-table::
   :widths: 100

   * - ZoneVO
   * - ClusterVO
   * - HostVO
   * - PrimaryStorageVO
   * - BackupStorageVO
   * - ImageVO
   * - InstanceOfferingVO
   * - DiskOfferingVO
   * - VolumeVO
   * - L2NetworkVO
   * - L3NetworkVO
   * - IpRangeVO
   * - VipVO
   * - EipVO
   * - VmInstanceVO
   * - VmNicVO
   * - SecurityGroupRuleVO
   * - SecurityGroupVO
   * - PortForwardingRuleVO
   * - VolumeSnapshotTreeVO
   * - VolumeSnapshotVO

衍生出的资源使用他们的父类型; 例如, SftpBackupStorage的资源类型是'BackupStorageVO'.
在每个资源的对应*Tags*章节中, 我们有解释需用用什么资源类型来创建对应的标签.

----------
操作（Operations）
----------

.. _create tags:

创建标签（Create Tags）
===========

有两种创建标签的方式; 对于已经创建的资源, 用户可以使用命令 CreateUserTag 或者 CreateSystemTag来创建用户标签或系统标签. 例如::

    CreateUserTag resourceType=DiskOfferingVO resourceUuid=50fcc61947f7494db69436ebbbefda34 tag=for-large-DB

::

    CreateSystemTag resourceType=HostVO resourceUuid=50fcc61947f7494db69436ebbbefda34 tag=reservedMemory::1G

对于一个将要被创建的资源, 因为它还没有被创建, 所以没有UUID可以被CreateUserTag和CreateSystemTag命令引用; 
在这种情况下, 用户可以使用每个“创建类型的API命令”（*creational API command*）的*userTags*和*systemTags*域, 在创建时，用户可以通过传递列表的形式定义多个标签;
例如::

    CreateVmInstance name=testTag systemTags=hostname::web-server-1
    userTags=in-super-data-center,has-public-IP,hot-fix-applied-2015-5-1
    l3NetworkUuids=6572ce44c3f6422d8063b0fb262cbc62
    instanceOfferingUuid=04b5419ca3134885be90a48e372d3895 imageUuid=f1205825ec405cd3f2d259730d47d1d8

参数（Parameters）
++++++++++

CreateUserTag和CreateSystemTag有相同的API参数:

.. list-table::
   :widths: 20 40 20 20
   :header-rows: 1

   * - 名字
     - 描述
     - 可选的
     - 起始支持版本
   * - **resourceUuid**
     - 资源UUID; 例如, 虚拟机的UUID, 计算方案的UUID
     -
     - 0.6
   * - **resourceType**
     - 资源类型; 参见 :ref:`resource type <tag resource type>`
     -
     - 0.6
   * - **tag**
     - 标签字符串
     -
     - 0.6

删除（Delete Tag）
==========

用户可以使用DeleteTag来删除一个用户标签或者一个非内部的系统标签. 例如::

    DeleteTag uuid=7813d03bb85840c489789f8df3a5915b

参数（Parameters）
++++++++++

.. list-table::
   :widths: 20 40 10 20 10
   :header-rows: 1

   * - 名字
     - 描述
     - 可选的
     - 可选的参数值
     - 其实支持版本
   * - **deleteMode**
     - 参见 :ref:`delete resource`
     - 是
     - - Permissive
       - Enforcing
     - 0.6
   * - **uuid**
     - 标签的UUID
     -
     -
     - 0.6

查询标签（Query Tags）
==========

用户可以使用QueryUserTag来查询用户标签, 例如::

    QueryUserTag resourceUuid=0cd1ef8c9b9e0ba82e0cc9cc17226a26 tag~=web-server-%

或使用QuerySystemTag来查询系统标签, 例如::

    QuerySystemTag resourceUuid=50fcc61947f7494db69436ebbbefda34

.. 注意:: 查询标签的时候, 由于资源的UUID唯一的标识了一个资源, 因此你不需要指定资源类型; 例如::

              QueryUserTag resourceUuid=0cd1ef8c9b9e0ba82e0cc9cc17226a26 resourceType=VmInstanceVO

          是冗余的， 因为ZStack知道资源UUID *0cd1ef8c9b9e0ba82e0cc9cc17226a26*对应于资源类型*VmInstanceVO*.

          并且不要忘记了你可以使用 *__userTag__* and *__systemTag__* 来通过标签查询资源, 请参见:ref:`Query API with tags <query with tags>`.
