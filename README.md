# FNetwork #
-----------------------------------  
FNetwork是基于Flex开发的大规模网络拓扑图形组件，可基于组件提供的SDK实现丰富的网络节点绘制和展示控制.<br>
主要说明如下： <br>
1、FNetwork可支持大规模节点(数千节点)拓扑关系准实时运算并展示，主要支持网络拓扑关系、伪2D和逼真2D物理资源等展示<br />
2、API文档请参见/docs/asdoc-api下的[index.html](http://htmlpreview.github.io/?https://github.com/ihedy/FNetwork/blob/master/docs/asdoc-api/index.html)<br />
3、核心类为：[Network.as](https://github.com/ihedy/FNetwork/blob/master/src/com/myflexhero/network/Network.as)，其次是 [NodeUI.as](https://github.com/ihedy/FNetwork/blob/master/src/com/myflexhero/network/core/ui/NodeUI.as)、 [SpringLayout.as](https://github.com/ihedy/FNetwork/blob/master/src/com/myflexhero/network/core/layout/SpringLayout.as) 等包装或逻辑处理类<br />
4、更多示例参见FNetworkTest工程，简单示例如下：<br />
5、代码始于2012年，在基于官方最新SDK开发时可能存在部分兼容性情况<br />
绘画2D房间:<br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/room.png) <br /><br />
拉伸、移动后:<br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/room1.png) <br /><br />
网络拓扑展示：<br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/spring.png) <br /><br />

Performance Testing：
-----------------------------------  
[MemoryTest.html(待提交)](http://htmlpreview.github.io/?https://github.com/ihedy/FNetworkTest/blob/master/bin-release/MemoryTest.html)<br /><br />
上千节点效果图(2500+Nodes)：
-----------------------------------  
![](https://github.com/ihedy/FNetwork/raw/master/intro/test.png)<br /><br />

-----------------------------------  
Architecture Description（Last updated in 2012）：
-----------------------------------  
![](https://github.com/ihedy/FNetwork/raw/master/intro/1.JPG)<br /><br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/2.JPG)<br /><br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/3.JPG)<br /><br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/4.JPG)<br /><br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/5.JPG)<br /><br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/6.JPG)<br /><br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/7.JPG)<br /><br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/8.JPG)<br /><br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/9.JPG)<br /><br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/10.JPG)<br /><br />
![](https://github.com/ihedy/FNetwork/raw/master/intro/11.JPG)<br /><br />

