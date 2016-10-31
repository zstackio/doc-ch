## API Title

### API Detail

-----------------------
操作（Operations）
-----------------------

创建端口转发规则（Create Port Forwarding Rule）
=========================================================

用户可以使用CreatePortForwardingRule来创建一个端口转发规则, 并可以同时挂载或者不挂载到虚拟机网卡上. 例如::

    CreatePortForwardingRule name=pf1 vipPortStart=22 vipUuid=433769b59a7c42199d762af01e08ec16 protocolType=TCP vmNicUuid=4b9c27321b794679a9ba8c18239bbb0d

一个未被挂载的规则可以稍后再挂载到虚拟机网卡上.
