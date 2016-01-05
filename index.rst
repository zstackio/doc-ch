==================
ZStack用户手册
==================

------------
介绍
------------

ZStack是一个开源的基础架构即服务的软件，用于管理数据中心中的计算、网络、存储等资源。
目前ZStack的核心代码主要用Java和Python编写。

本文档主要介绍ZStack的各个功能模块以及相关的API手册。如果你还没有安装ZStack，可以参考`ZStack官网<http://zstack.org/cn>`
来安装和使用ZStack。

用户手册里会详细介绍ZStack的各个功能模块。每个功能是一章，每一章还会划分为以下几个部分：

- **简介**: 简单介绍一下该功能的背景。

- **数据结构（Inventory）**: 介绍该功能各种资源(例如主机区域（zone）, 虚拟机（virtual machine）)的数据结构，
  也就是在使用各种Query API得到的返回结果。 我们会使用表格来展示数据结构，表格的左边是资源的名字，右侧会介绍该资源的用途。

- **操作**: 介绍和该功能有关的API操作。我们还将结合ZStack的命令行工具`zstack-cli`来介绍每个API的使用方法。

- **全局配置（Global Configurations）**: 介绍和该功能有关的全局配置参数。

- **系统标签（System Tags）**: 介绍和该功能有关的系统标签。

我们推荐用户从:ref:`Introduction`开始，然后至少阅读:ref:`Resource Model <resource>`, :ref:`Command Line Tool <cli>`,
和:ref:`Query <query>` 。这些将会对日常使用ZStack非常关键。对于其他章节，你可以按需阅读。
例如，当你需要创建虚拟机的时候，再来阅读 :ref:`Virtual Machine <vm>` 。

--------
目录
--------

.. toctree::
    :maxdepth: 1

    userManual/introduction
    userManual/resource
    userManual/cli
    userManual/query
    userManual/globalConfigure
    userManual/tag
    userManual/zone
    userManual/cluster
    userManual/host
    userManual/primaryStorage
    userManual/l2Network
    userManual/l3Network
    userManual/image
    userManual/backupStorage
    userManual/volume
    userManual/diskOffering
    userManual/instanceOffering
    userManual/vm
    userManual/securityGroup
    userManual/virtualRouter
    userManual/vip
    userManual/portForwarding
    userManual/eip
    userManual/volumeSnapshot
    userManual/lb

