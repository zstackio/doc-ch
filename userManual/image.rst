.. _image:

=====
镜像（Image）
=====

.. contents:: `目录`
   :depth: 6

--------
概览（Overview）
--------

镜像为虚拟机文件系统提供模板. 镜像可以是为虚拟机安装操作系统的根云盘（root volume）提供模板的RootVolumeTemplate; 
镜像也可以是为虚拟机存储非操作系统数据的数据云盘（data volumes）提供模板的DataVolumeTemplate; 
同时镜像也可以是用来在空白根云盘（blank root volumes）上安装操作系统的ISO文件.

镜像存储在:ref:`backup storage <backup storage>`上. 如果在启动虚拟机之前, 用来创建虚拟机根云盘的镜像还不在:ref:`primary storage <primary storage>`的镜像缓存（image cache）中, 镜像会先被下载到缓存中. 
因此在首次用一个镜像创建创建虚拟机的时候，通常会由于需要下载而花费更多的时间.

ZStack使用`thin provisioning <http://en.wikipedia.org/wiki/Thin_provisioning>`_创建根云盘. 
从相同镜像创建出来的根云盘共享主存储的镜像缓存中同一份基础镜像（base image），对某个虚拟机根云盘的改动不会影响到基础镜像.

.. _image inventory:

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
   * - **state**
     - 请参见 :ref:`state <image state>`
     -
     - - Enabled
       - Disabled
     - 0.6
   * - **status**
     - 请参见 :ref:`status <image status>`
     -
     - - Creating
       - Downloading
       - Ready
     - 0.6
   * - **size**
     - 镜像大小, 单位是字节
     -
     -
     - 0.6
   * - **url**
     - 镜像注册的url, 请参见 :ref:`url <image url>`
     -
     -
     - 0.6
   * - **mediaType**
     - 镜像的媒介类型, 请参见 :ref:`media type <image media type>`
     -
     - - RootVolumeTemplate
       - DataVolumeTemplate
       - ISO
     - 0.6
   * - **guestOsType**
     - 该字符串描述了虚拟机的操作系统类型
     - 是
     -
     - 0.6
   * - **platform**
     - 虚拟机的操作系统平台, 请参见 :ref:`platform <image platform>`
     -
     - - Linux
       - Windows
       - Paravirtualization
       - Other
     - 0.6
   * - **system**
     - 请参见 :ref:`system image <system image>`
     -
     -
     - 0.6
   * - **format**
     - 请参见 :ref:`format <image format>`
     -
     - - qcow2
       - raw
     - 0.6
   * - **md5Sum**
     - 镜像的md5校验值

       .. 注意:: 当前版本的ZStack不会计算MD5校验值
     -
     -
     - 0.6
   * - **type**
     -  保留的域
     -
     - - zstack
     - 0.6
   * - **backupStorageRefs**
     - :ref:`backup storage reference <image backup storage reference>`列表
     -
     -
     - 0.6

示例
=======

::

        {
            "backupStorageRefs": [
                {
                    "backupStorageUuid": "8b99641a4d644820932e0ec5ada78eed",
                    "createDate": "Jun 1, 2015 6:17:48 PM",
                    "imageUuid": "b395386bdb4a4ff1b1850a457c949c5e",
                    "installPath": "/export/backupStorage/sftp/templates/acct-36c27e8ff05c4780bf6d2fa65700f22e/b395386bdb4a4ff1b1850a457c949c5e/centos_400m_140925.template",
                    "lastOpDate": "Jun 1, 2015 6:17:48 PM"
                }
            ],
            "createDate": "Jun 1, 2015 6:17:40 PM",
            "description": "Test Image Template for network test",
            "format": "qcow2",
            "guestOsType": "unknown",
            "lastOpDate": "Jun 1, 2015 6:17:40 PM",
            "md5Sum": "not calculated",
            "mediaType": "RootVolumeTemplate",
            "name": "image_for_sg_test",
            "platform": "Linux",
            "size": 419430400,
            "state": "Enabled",
            "status": "Ready",
            "system": false,
            "type": "zstack",
            "url": "http://172.16.0.220/templates/centos_400m_140925.img",
            "uuid": "b395386bdb4a4ff1b1850a457c949c5e"
        },

.. _image state:

可用状态（State）
=====

镜像有两种可用状态:

- **Enabled**:

  在这种状态下，允许创建基于该镜像的虚拟机

- **Disabled**:

  在这种状态下，不允许创建基于该镜像的虚拟机

.. _image status:

连接状态（Status）
======

连接状态反应了镜像的生命周期（lifecycle）:

- **Creating**:

  正在从云盘或云盘快照（volume snapshot）创建镜像; 未就绪不能使用.

- **Downloading**:

  正在从url下载镜像; 未就绪不能使用.

- **Ready**:

  镜像已经在备份存储中；已就绪可以使用.

.. _image url:

URL
===

镜像在备份存储中创建的方式不同，url的含义也会不同; 如果镜像是从网页服务器下载的，url就是HTTP/HTTPS链接; 如果镜像是从云盘或者云盘快照创建的, url就是云盘或云盘快照的UUID的字符串编码, 例如::

    volume://b395386bdb4a4ff1b1850a457c949c5e
    volumeSnapshot://b395386bdb4a4ff1b1850a457c949c5e

.. 注意:: ZStack当前版本仅支持使用AddImage从HTTP/HTTPS链接URL创建镜像到备份存储.


.. _image media type:

媒介类型（Media Type）
==========

媒介类型指示了镜像的用途.

- **RootVolumeTemplate**:

  镜像被用来创建根云盘.

- **DataVolumeTemplate**:

  镜像被用来创建数据云盘.

- **ISO**:

  镜像被用来在空白的根云盘上安装操作系统.

.. _image platform:

平台（Platform）
========

ZStack根据平台来判断从该镜像创建虚拟机是否要使用半虚拟化（`paravirtualization <http://en.wikipedia.org/wiki/Paravirtualization>`_）.

.. list-table::
   :widths: 50 50

   * - 使用半虚拟化
     - - Linux
       - Paravirtualization
   * - 不使用半虚拟化（虚拟机磁盘使用IDE模式，网卡使用e1000）
     - - Windows
       - Other

.. _system image:

系统镜像（System Image）
============

系统镜像仅被用来创建特殊应用虚拟机（appliance VMs），因而不被用户虚拟机使用. ZStack当前版本使用系统镜像创建:ref:`virtual router <virtual router>`.


.. _image format:

格式（Format）
======

格式反映了虚拟机管理程序和镜像之间的关系. 例如, qcow2格式的镜像仅能被KVM虚拟机使用.
ZStack当前版本仅支持KVM虚拟机管理程序, 因此关系表如下:


.. list-table::
   :widths: 50 50
   :header-rows: 1

   * - 虚拟机管理程序类型
     - 格式
   * - KVM
     - - qcow2
       - raw

创建的云盘会从其所基于的镜像继承格式信息; 例如, 从qcow2格式的镜像创建的根云盘同样会是qcow2格式.
'raw'格式是个特例, 从'raw'格式的镜像创建的云盘会使用qcow2格式，因为ZStack会通过qcow2格式使用thin-clone.

.. _image backup storage reference:

备份存储引用（Backup Storage Reference）
========================

一个镜像可以存储在一个或多个备份存储中. 对于所存储的每个备份存储, 镜像都有一个包含了备份存储UUID以及镜像安装路径的备份存储引用.


.. list-table::
   :widths: 20 40 10 20 10
   :header-rows: 1

   * - 名字
     - 描述
     - 可选的
     - 可选的参数值
     - 起始支持版本
   * - **imageUuid**
     - 镜像的uuid
     -
     -
     - 0.6
   * - **backupStorageUuid**
     - 备份存储的uuid, 请参见 :ref:`backup storage <backup storage>`
     -
     -
     - 0.6
   * - **installPath**
     - 在备份存储上的安装路径
     -
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
+++++++

::

     {
         "backupStorageUuid": "8b99641a4d644820932e0ec5ada78eed",
         "imageUuid": "b395386bdb4a4ff1b1850a457c949c5e",
         "installPath": "/export/backupStorage/sftp/templates/acct-36c27e8ff05c4780bf6d2fa65700f22e/b395386bdb4a4ff1b1850a457c949c5e/centos_400m_140925.template",
         "createDate": "Jun 1, 2015 6:17:48 PM",
         "lastOpDate": "Jun 1, 2015 6:17:48 PM"
     }


----------
操作（Operations）
----------

.. _add image:

添加镜像（Add Image）
=========

管理员可以使用AddImage来添加镜像. 例如::

    AddImage name=CentOS7 format=qcow2 backupStorageUuids=8b99641a4d644820932e0ec5ada78eed url=http://172.16.0.220/templates/centos7_400m_140925.img mediaType=RootVolumeTemplate platform=Linux

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
   * - **url**
     - HTTP/HTTPS url, 请参见 :ref:`url <image url>`
     -
     -
     - 0.6
   * - **mediaType**
     - 镜像媒介类型, 请参见 :ref:`media type <image media type>`. 默认为RootVolumeTemplate
     - 是
     - - RootVolumeTemplate
       - DataVolumeTemplate
       - ISO
     - 0.6
   * - **guestOsType**
     - 指示虚拟机操作系统类型的字符串, 例如, CentOS7
     - 是
     -
     - 0.6
   * - **system**
     - 指示是否为系统镜像, 请参见 :ref:`system image <system image>`. 默认为false
     - 是
     - - true
       - false
     - 0.6
   * - **format**
     - 镜像格式, 请参见 :ref:`format <image format>`
     -
     - - qcow2
       - raw
     - 0.6
   * - **platform**
     - 镜像的平台, 请参见 :ref:`platform <image platform>`. 默认为Linux
     - 是
     - - Linux
       - Windows
       - Other
       - Paravirtualization
     - 0.6
   * - **backupStorageUuids**
     - 镜像将要挂载的备份存储uuid列表
     -
     -
     - 0.6
   * - **type**
     - 保留的域, 请勿使用
     - 是
     - - zstack
     - 0.6

可以通过在'backupStorageUuids'参数中提供一个备份存储UUID列表，将一个镜像添加到多个备份存储;
只要镜像被成功加载到一个备份存储AddImage命令就会返回成功, 只有当其在所有备份存储上失败时才返回失败.
成功将镜像添加的备份存储可以从API返回的镜像清单中的:ref:`image backup storage reference <image backup storage reference>`获得.

删除镜像（Delete Image）
============

管理员可以使用DeleteImage从指定的或全部的备份存储中删除一个镜像. 例如::

    DeleteImage uuid=b395386bdb4a4ff1b1850a457c949c5e backupStorageUuids=c310386bdb4a4ff1b1850a457c949c5e,f295386bdb4a4ff1b1850a457c949c5e

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
     - 镜像的uuid
     -
     -
     - 0.6
   * - **deleteMode**
     - 请参见 :ref:`delete resource`
     - 是
     - - Permissive
       - Enforcing
     - 0.6
   * - **backupStorageUuids**
     - 存储该镜像的备份存储列表; 如果不指定该参数，该镜像会从所有的备份存储中删除.
     -
     -
     - 0.6

仅当从所有备份存储中删除后，镜像才被认为是被删除了; 否则，镜像只是从部分备份存储中被删除.

.. 危险:: 没有办法恢复一个从所有备份存储上删除了的镜像.

改变可用状态（Change State）
============

管理员可以使用ChangeImageState来改变镜像的可用状态. 例如::

    ChangeImageState stateEvent=enable uuid=b395386bdb4a4ff1b1850a457c949c5e

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
     - 镜像的uuid
     -
     -
     - 0.6
   * - **stateEvent**
     - 状态触发事件（state trigger event）

       - 启用: 改变可用状态为启用（Enabled）
       - 禁用: 改变可用状态为禁用（Disabled）
     -
     - - enable
       - disable
     - 0.6

从根云盘创建RootVolumeTemplate（Create RootVolumeTemplate From Root Volume）
==========================================

用户可以从根云盘创建RootVolumeTemplate镜像. 例如::

    CreateRootVolumeTemplateFromRootVolume name=CentOS7 rootVolumeUuid=1ab2386bdb4a4ff1b1850a457c949c5e backupStorageUuids=backupStorageUuids,f295386bdb4a4ff1b1850a457c949c5e

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
   * - **backupStorageUuids**
     - 该备份存储uuid列表选择镜像将在哪些备份存储上创建, 请参见 :ref:`backup storage uuids <backup storage uuids1>`
     - 是
     -
     - 0.6
   * - **rootVolumeUuid**
     - 即将用于创建该镜像的根云盘的uuid
     -
     -
     - 0.6
   * - **platform**
     - 镜像的平台, 请参见 :ref:`platform <image platform>`; 默认为Linux
     - 是
     - - Linux
       - Windows
       - Other
       - Paravirtualization
     - 0.6
   * - **guestOsType**
     - 该字符串存储了虚拟机的操作系统类型, 例如, CentOS7
     - 是
     -
     - 0.6
   * - **system**
     - 指示该镜像是否为系统镜像, 请参见 :ref:`system image <system image>`; 默认为false
     - 是
     - - true
       - false
     - 0.6

.. _backup storage uuids1:

备份存储UUID（Backup Storage UUIDs）
++++++++++++++++++++

当调用CreateRootVolumeTemplateFromRootVolume时, 用户可以提供一个备份存储UUID里列表来指定在哪里创建镜像;
如果忽略这个域, 会随机选择一个备份存储创建镜像.

.. _create RootVolumeTemplate from volume snapshot:

从云盘快照创建RootVolumeTemplate（Create RootVolumeTemplate From Volume Snapshot）
==============================================

用户可以使用CreateRootVolumeTemplateFromVolumeSnapshot从云盘快照创建一个RootVolumeTemplate. 例如::

    CreateRootVolumeTemplateFromVolumeSnapshot name=CentOS7 snapshotUuid=1ab2386bdb4a4ff1b1850a457c949c5e

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
   * - **snapshotUuid**
     - 云盘快照的uuid, 请参见 :ref:`volume snapshot <volume snapshot>`
     -
     -
     - 0.6
   * - **backupStorageUuids**
     - 该备份存储uuid列表选择镜像将在哪些备份存储上创建, 请参见 :ref:`backup storage uuids <backup storage uuids2>`
     - 是
     -
     - 0.6
   * - **platform**
     - 镜像平台, 请参见 :ref:`platform <image platform>`. 默认为Linux
     - 是
     - - Linux
       - Windows
       - Other
       - Paravirtualization
     - 0.6
   * - **guestOsType**
     - 该字符串指示了虚拟机的操作系统类型, 例如, CentOS7
     - 是
     -
     - 0.6
   * - **system**
     - 指示该镜像是否为系统镜像, 请参见 :ref:`system image <system image>`. Default is false
     - 是
     - - true
       - false
     - 0.6

.. _backup storage uuids2:

备份存储uuid（Backup Storage Uuids）
++++++++++++++++++++

当调用CreateRootVolumeTemplateFromVolumeSnapshot时, 用户可以提供一个备份存储UUID里列表来指定在哪里创建镜像;
如果忽略这个域, 会随机选择一个备份存储创建镜像.

从云盘创建DataVolumeTemplate（Create DataVolumeTemplate From Volume）
=====================================

用户可以使用CreateDataVolumeTemplateFromVolume来从云盘创建一个DataVolumeTemplate. 例如::

    CreateDataVolumeTemplateFromVolume name=data volumeUuid=1ab2386bdb4a4ff1b1850a457c949c5e

这里的云盘，可以是根云盘，也可以是数据云盘. 因此这里提供了一种从根云盘创建数据云盘的方法.
用户可以先从根云盘创建一个DataVolumeTemplate, 然后基于该DataVolumeTemplate再创建数据云盘.

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
   * - **volumeUuid**
     - 云盘的uuid, 请参见 :ref:`volume <volume>`
     -
     -
     - 0.6
   * - **backupStorageUuids**
     - 该备份存储uuid列表选择镜像将在哪些备份存储上创建, 请参见 :ref:`backup storage uuids <backup storage uuids3>`
     - 是
     -
     - 0.6

.. _backup storage uuids3:

Backup Storage Uuids
++++++++++++++++++++

当调用CreateDataVolumeTemplateFromVolume时, 用户可以提供一个备份存储UUID里列表来指定在哪里创建镜像;
如果忽略这个域, 会随机选择一个备份存储创建镜像.

查询镜像（Query Image）
===========

用户可以使用QueryImage来查询镜像. 例如::

    QueryImage status=Ready system=true

::

    QueryImage volume.vmInstanceUuid=85ab231e392d4dfb86510191278e9fc3


原生域查询（Primitive Fields of Query）
+++++++++++++++++++++++++

请参见 :ref:`image inventory <image inventory>`

嵌套和扩展域查询（Nested And Expanded Fields of Query）
+++++++++++++++++++++++++++++++++++

.. list-table::
   :widths: 20 30 40 10
   :header-rows: 1

   * - 域（Field）
     - 清单（Inventory）
     - 描述
     - 起始支持版本
   * - **backupStorage**
     - :ref:`backup storage inventory <backup storage inventory>`
     - 该镜像所在的备份存储
     - 0.6
   * - **volume**
     - :ref:`volume inventory <volume inventory>`
     - 从该镜像创建的所有云盘
     - 0.6
   * - **backupStorageRef**
     - :ref:`backup storage reference <image backup storage reference>`
     - 用来查询备份存储安装路径的引用
     - 0.6

----
标签（Tags）
----

用户可以使用resourceType=ImageVO在镜像上创建用户标签. 例如::

    CreateUserTag resourceType=ImageVO tag=golden-image resourceUuid=ff7c04c4e2874a21a3e795501f1bc516
