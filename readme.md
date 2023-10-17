<a name="GNIcx"></a>
## 1.文件构成
1. decimation_filter模型包括一个simulink模型以及一个，matlab脚本文件组成（.m和.slx）。其中基本框架在simulink中搭建，脚本用于计算FIR滤波器的简化后系数与绘制频响图像。
2. 在运行相关模型前，需要确保在matlab路径中已经添加了SDtoolbox，正常的matlab没有，需要另外安装。
<a name="CN3yH"></a>
## 2.matlab脚本说明

1. matlab脚本支持进行频响图形绘制，对于不同mode均实现了CICC滤波器以及Halfband完整代码;CIC只实现了128的mode，可以通过下面代码的修改实现不同的mode
```matlab
% CIC 128 MODE 25BIT
fs= 6e6;
R = 128;  % decimator factor
D = 1;  % differential delay 
N = 3;  % number of stage 13.46*3=40.4 dB

CICDecim = dsp.CICDecimator(R, D, N);
fs_ciccom_128m = 23437.5*2;
fPass_ciccom_128m = fs/2048;
fStop_ciccom_128m = 20000;

```

2. 频响图形绘制的是全精度的浮点系数的FIR滤波器，且在脚本代码中只有单个滤波器的频响，需要看级联滤波器的频响特性可以通过下面的**cascade函数**进行修改
```matlab
fvtool(CICDecim,CICCompDecim_128m,...
cascade(CICDecim,CICCompDecim_128m),'ShowReference','off','Fs');

legend('CIC Decimator','CIC Compensator','Resulting Cascade Filter');
```

3. 对于模型使用了限制精度后的整型参数FIR滤波器，对于精度的修改可以通过下面代码语句的修改进行。
```matlab
coff_ciccom_round_128m = round(coff_ciccom_128m * 2^11);% 将参数扩大2^11倍
coff_ciccom_round_256m = round(coff_ciccom_256m * 2^11);
coff_ciccom_round_64m = round(coff_ciccom_64m * 2^11);
```
<a name="vJPU2"></a>
## 3.simulink model说明
**在运行simulink前请先确保运行了上面的脚本文件，否则会报错**
<a name="ZbR7n"></a>
### 3.1整体结构
![image.png](https://cdn.nlark.com/yuque/0/2023/png/2676552/1697540447252-5151b7e6-3ac4-435c-a527-d9295c7299cb.png#averageHue=%23f9f9f9&clientId=u34a65a7b-134c-4&from=paste&height=874&id=u9ffd13ad&originHeight=874&originWidth=939&originalType=binary&ratio=1&rotation=0&showTitle=false&size=77099&status=done&style=none&taskId=u89027b24-acb7-47e5-bb6d-134ae77a1d5&title=&width=939)

1. 对于整个模型由三部分组成，三部分中可以通过修改input signal来生成不同的测试向量，modulator是模拟部分的model，可以看做黑盒。后端滤波器主要分为两大部分，每个部分有三个mode。
2. 1处是FIR使用了浮点参数的滤波器，属于全精度模型，可以作为参考，具体参数的查看可以按照下图的步骤。2处则是使用了通过脚本进行精度调整后的整形参数滤波器。

![image.png](https://cdn.nlark.com/yuque/0/2023/png/2676552/1697541016570-21d5ecfe-7ea2-4368-8f50-c6c8584d88ce.png#averageHue=%23f6f6f6&clientId=u34a65a7b-134c-4&from=paste&height=681&id=u0d48249c&originHeight=681&originWidth=1607&originalType=binary&ratio=1&rotation=0&showTitle=false&size=153031&status=done&style=none&taskId=u95a72592-c2e9-49f1-86ae-bf871641860&title=&width=1607)

3. 无论是1还是2中都有3个mode，分别对应了CIC滤波器的不同的降采样系数，三个mode通过增加半带滤波器的数量保证了总的降采样律均为1024
<a name="biflI"></a>
### 3.2 CIC滤波器详细解释

1. 对于CIC滤波器的设计而言，重点考虑非全精度情况，为了保证SNR的计算，这里的取值使用了有符号数（如下图），从而避免了直流分量对SNR计算的影响，**但是最终提供的数码只有4bit且无符号！请根据需要进行特殊处理**

![image.png](https://cdn.nlark.com/yuque/0/2023/png/2676552/1697541338908-d0903655-bed3-48c2-bfc5-1fbc060d2669.png#averageHue=%23f5f4f3&clientId=u34a65a7b-134c-4&from=paste&height=296&id=u6f4341db&originHeight=381&originWidth=990&originalType=binary&ratio=1&rotation=0&showTitle=false&size=72353&status=done&style=none&taskId=u6e4f5aa4-b953-4f24-b5db-346fa26be28&title=&width=770)

2. 对于不同降采样律的情况，CIC字长理论公式为$N=B+S\log_2{R}$其中B为输入字长，S为阶数，R为降采样数，所以理论上对于降采样律为64,128,256三个mode，字长分别为22,25,28bit。在simulink中已按照此字长设置，并已验证了小于字长的情况。如要修改只能增加。修改方法见下图：两个converter均要修改。

![image.png](https://cdn.nlark.com/yuque/0/2023/png/2676552/1697541762741-cd883a97-adc4-45dc-a7c1-1bd1b728888d.png#averageHue=%23f6f5f5&clientId=u34a65a7b-134c-4&from=paste&height=523&id=ua9090de6&originHeight=523&originWidth=1330&originalType=binary&ratio=1&rotation=0&showTitle=false&size=102025&status=done&style=none&taskId=u228954ec-3704-437f-8598-68295dce141&title=&width=1330)

3. 任何修改之后请单独检查CIC每一部分的波形图，以及最终输出的频谱，注意信号是否有大的直流分量以及相干采样。
<a name="sjUnE"></a>
### 3.3 调制器输出详细解释
![image.png](https://cdn.nlark.com/yuque/0/2023/png/2676552/1697541882596-500b4aa8-0f9c-404e-a2fb-6c86901ac1ec.png#averageHue=%23f4f4f4&clientId=u34a65a7b-134c-4&from=paste&height=341&id=u09c7c412&originHeight=341&originWidth=437&originalType=binary&ratio=1&rotation=0&showTitle=false&size=15726&status=done&style=none&taskId=u4dc6ba71-6eb4-44cc-8ed5-0e91a656fa8&title=&width=437)<br />对于实际使用，如果是全精度，请直接在Out2进行输出。如果是经过精度调整的情况，主要关注Out3和Out4，其中Out3是将0000到1111均匀映射到0到15，Out4是为了上面的fft做了特殊处理，但也是整数类型的映射。具体可以自己接个scope查看.
<a name="TaBwx"></a>
### 3.3 FIR滤波器详细解释

1. 如果想看每一级滤波器输出频谱，请严格遵循相干采样定律，也可以在现有基础上进行快速修改。
2. 具体修改时需要修改两个地方以保证满足相干采样，如下图所示，首先修改PSD模块，在1位置进行图像的编号修改，以免混淆；结合当前psd位置计算降采样律，如下图128的cic和一个cicc（cicc和halfband均为2倍降采样），总的降采样律为256，修改2,3中对应参数位置即可。

![image.png](https://cdn.nlark.com/yuque/0/2023/png/2676552/1697542296074-ce80c869-2037-4dd8-a00e-505fb7cda1ad.png#averageHue=%23f8f8f8&clientId=u34a65a7b-134c-4&from=paste&height=552&id=u873930a7&originHeight=552&originWidth=1665&originalType=binary&ratio=1&rotation=0&showTitle=false&size=98132&status=done&style=none&taskId=u3a9e7b91-1eb0-406b-87d8-0eada5b6519&title=&width=1665)
