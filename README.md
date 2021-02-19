# Demo

Demo1：present 和 dismiss 转场动画（包含键盘联动的inputAccessoryView）  
示例：  
![img](https://github.com/weexiaoqiang1987/Demo/blob/main/images-folder/transitionn.gif)   

要求：a控制器的a1控件动画过渡为b控制器的b1控件，且b1为inputAccessoryView，动画过程设计b控制器展现时b1控件随键盘弹出  

问题：1. push方式转场动画不弹键盘  
            2. present方式弹键盘，过去不到准确的目标控件位置，因为控件随键盘变化  
技术点：  
push方式自定义转场动画，键盘弹出不受开发者控制。  
present 方式自定义转场动画，键盘弹出可以控制。  
获取inputAccessoryView的frame需要在主线程  
  
注意：获取目标控制器中随键盘动态变化位置的控件frame，需要在主线程中进行，不然转场过程中目标位置不准确  
