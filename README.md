# AASphereView
**先来看实现的效果：**

![Dec-03-2018 15-34-29.gif](https://upload-images.jianshu.io/upload_images/3569202-5717156fc8125f73.gif?imageMogr2/auto-orient/strip)

**主要有两个难点：**

1. 在空间中构建一个球形，并将子视图均匀的分布在球面上
2. 球滚动时，球面坐标的计算

>实现的思路主要来自于[DBSphereTagCloud](https://github.com/dongxinb/DBSphereTagCloud)，方法基本相似；球面运动时的坐标运算使用了[SwiftNum](https://github.com/donald-pinckney/SwiftNum)

#### 1.先来构建一个球来摆放子视图

**思路：** 我们按照需要展示的子视图个数沿着z轴将球体等分成相应份数，然后按照一个常数`angle`角度来做旋转，构造一个沿着球面的螺旋，这个常数角度的选择有些门道，要让他的循环周期尽量长，不然很容易看到我们的球面像西瓜一样被等分成几瓣，如果我们设置成π/4，我们来看一下等分的效果

![image.png](https://upload-images.jianshu.io/upload_images/3569202-49bc1b28a8a2a10c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以看到球面被分成了8瓣，不是我们要的球面的效果，代码里这个角度参考了[DBSphereTagCloud](https://github.com/dongxinb/DBSphereTagCloud)，我们来看代码：

```
    func setTagViews(array: [UIView]) {
        
        self.tagViews = array
        
        let angle = CGFloat.pi * (3 - sqrt(5))
        for i in 0..<array.count {
            
            //从（0，0，-1）点沿z轴方向等分（-1，1）区间，然后做一个螺旋铺满球面
            let z: CGFloat = CGFloat(i) * 2.0 / CGFloat(array.count) - 1.0 + 1.0 / CGFloat(array.count)
            let radius = sqrt(1.0 - z * z)
            let angle_i = angle * CGFloat(i)
            let x = radius * cos(angle_i)
            let y = radius * sin(angle_i)
            let location = AAPoint.init(x: x, y: y, z: z)
            self.coordinates.append(location)
            
            //将所有标签从视图中心用一个动画散部到整个球面上
            let view = array[i]
            self.addSubview(view)
            view.center = CGPoint.init(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
            let duration = Double(arc4random() % 10 + 10) / 20.0   //0.5~1.0s
            UIView.animate(withDuration: duration) {
                self.setViewWith(coordinate: location, at: i)
            }
            
        }
        
    }
```
#### 2.球面旋转，坐标计算

**思路：** 这里的球面坐标计算比较复杂，使用了矩阵计算，我调用了[SwiftNum](https://github.com/donald-pinckney/SwiftNum)现成的接口。
这里传入的translation是旋转的位移，投影在xy坐标系上，作用域为（-1，1）

```
mutating func rotate(translation: CGPoint) {
        
        guard translation.x != 0 || translation.y != 0 else {
            return
        }
        
        let translation = CGPoint.init(x: -translation.y, y: translation.x)
        var temp = Array.init(repeating: Array.init(repeating: 0.0, count: 4), count: 4)
        temp[0] = [Double(self.x), Double(self.y), Double(self.z), 1.0]
        
        var result: Matrix = Matrix.init(temp)
        if translation.y != 0 {
            
            let cos1 = Double(0)
            let sin1 = translation.y > 0 ? 1.0 : -1.0
            let t1 = [[1, 0, 0, 0], [0, cos1, sin1, 0], [0, -sin1, cos1, 0], [0, 0, 0, 1]]
            result *= Matrix.init(t1)
            
        }
        
        if pow(translation.x, 2) + pow(translation.y, 2) != 0 {
            
            let cos2 = abs(translation.y) / sqrt(pow(translation.x, 2) + pow(translation.y, 2))
            let sin2 = -translation.x / sqrt(pow(translation.x, 2) + pow(translation.y, 2))
            let t2 = [[Double(cos2), 0, Double(-sin2), 0], [0, 1, 0, 0], [Double(sin2), 0, Double(cos2), 0], [0, 0, 0, 1]]
            result *= Matrix.init(t2)
            
        }
        
        let cos3 = Double(cos(sqrt(pow(translation.x, 2) + pow(translation.y, 2))))
        let sin3 = Double(sin(sqrt(pow(translation.x, 2) + pow(translation.y, 2))))
        let t3 = [[cos3, sin3, 0, 0], [-sin3, cos3, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]
        result *= Matrix.init(t3)
        
        if pow(translation.x, 2) + pow(translation.y, 2) != 0 {
            
            let cos2 = abs(translation.y) / sqrt(pow(translation.x, 2) + pow(translation.y, 2))
            let sin2 = -translation.x / sqrt(pow(translation.x, 2) + pow(translation.y, 2))
            let t2 = [[Double(cos2), 0, Double(sin2), 0], [0, 1, 0, 0], [Double(-sin2), 0, Double(cos2), 0], [0, 0, 0, 1]]
            result *= Matrix.init(t2)
            
        }
        
        if translation.y != 0 {
            
            let cos1 = Double(0)
            let sin1 = translation.y > 0 ? 1.0 : -1.0
            let t1 = [[1, 0, 0, 0], [0, cos1, -sin1, 0], [0, sin1, cos1, 0], [0, 0, 0, 1]]
            result *= Matrix.init(t1)
            
        }
        
        x = CGFloat(result[0, 0])
        y = CGFloat(result[0, 1])
        z = CGFloat(result[0, 2])
        
    }
```

>这里是[Demo](https://github.com/Fxxxxxx/AASphereView)，如果想要直接使用我封装好的视图的话，直接把demo里的`AASphereView`文件夹拉入项目即可，因为这个项目也是参考了大神的代码，所以就不单独上传Cocoapods或者Carthage了，避免侵权，欢迎交流👏
