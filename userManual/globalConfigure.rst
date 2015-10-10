.. _global configure:

=====================
全局配置（Global Configurations）
=====================

.. contents:: `目录`
   :depth: 6

--------
概览
--------

管理员可以使用全局配置（global configurations）来对很多特性（feature）进行配置; 所有的全局配置都有一个默认值; 更新全局配置并不需要重启管理节点.

对于资源相关的全局配置都被安排在相关章节中，对于那些不能归类到任何资源的配置都被列举在本章节中.

---------
清单（Inventory）
---------

.. list-table::
   :widths: 20 40 10 20 10
   :header-rows: 1

   * - 名字
     - 描述
     - 此参数可选
     - 可选参数值
     - 起始支持版本
   * - **category**
     - 配置类别
     -
     -
     - 0.6
   * - **description**
     - 配置描述
     -
     -
     - 0.6
   * - **name**
     - 配置名字
     -
     -
     - 0.6
   * - **defaultValue**
     - 默认值
     -
     -
     - 0.6
   * - **value**
     - 当前值
     -
     -
     - 0.6

示例
=======

::

        {
            "category": "identity",
            "defaultValue": "500",
            "description": "管理服务器可以接受的最大会话数量. 达到这个限制值时，新的会话会被拒绝",
            "name": "session.maxConcurrent",
            "value": "500"
        }


----------
操作（Operations）
----------

更新全局配置
============================

管理员可以使用UpdateGlobalConfig来更新一个全局配置. 例如::

    UpdateGlobalConfig category=host name=connection.autoReconnectOnError value=true


--------------------
其他配置
--------------------

不能归类到单独一个章节的一些配置.


.. _cloudBus.statistics.on:

statistics.on
=============

.. list-table::
   :widths: 20 30 20 30
   :header-rows: 1

   * - 名字
     - 类别
     - 默认值
     - 可选参数值
   * - **statistics.on**
     - cloudBus
     - false
     - - true
       - false

开启或关闭通过JMX统计的每个消息消耗的时间.


.. _node.heartbeatInterval:

node.heartbeatInterval
======================

.. list-table::
   :widths: 20 30 20 30
   :header-rows: 1

   * - 名字
     - 类别
     - 默认值
     - 可选参数值
   * - **node.heartbeatInterval**
     - managementServer
     - 5
     - > 0

管理节点向数据库写心跳（heartbeat)的间隔时间, 单位是秒.


.. _node.joinDelay:

node.joinDelay
==============

.. list-table::
   :widths: 20 30 20 30
   :header-rows: 1

   * - 名字
     - 类别
     - 默认值
     - 可选参数值
   * - **node.joinDelay**
     - managementServer
     - 0
     - >= 0

当值为非0时，每个管理节点在消息总线上发布加入事件(join event)之前会延迟0到'node.joinDelay'秒.
这是为了避免当有大量的管理节点同时上线时会产生加入事件风暴.


.. _configuration.key.public:

key.public
==========

.. list-table::
   :widths: 20 30 20 30
   :header-rows: 1

   * - 名字
     - 类别
     - 默认值
     - 可选参数值
   * - **key.public**
     - configuration
     - 请查看你的数据库
     -

ZStack会把这个SSH公钥（public SSH key）注入到需要部署代理（agent）的Linux服务器上; 在当前版本中, Linux服务器包含KVM主机, 虚拟路由器虚拟机（virtual router VMs）,
SFTP备份存储（SFTP backup storage）. 成功注入后, ZStack在需要SSH登陆时会使用:ref:`key.private <configuration.key.private>`.


.. _configuration.key.private:

key.private
===========

.. list-table::
   :widths: 20 30 20 30
   :header-rows: 1

   * - 名字
     - 类别
     - 默认值
     - 可选参数值
   * - **key.private**
     - configuration
     - 请查看你的数据库
     -

Zstack用来SSH登陆远程Linux服务器的SSH私钥（private SSH key）; 请参看:ref:`key.public <configuration.key.public>`.
