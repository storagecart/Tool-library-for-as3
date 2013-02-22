package tool.third.component
{
	import flash.events.MouseEvent;	
	import flash.events.Event;	
	import flash.display.SimpleButton;	
	import flash.text.TextField;	
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.geom.Rectangle;

	/**
	 * @author 寂寞火山 http://www.huoshan.org
	 * @version V5 [08.3.15]
	 * 备注：动态文本滚动条
	 */
	public class ScrollBar extends Sprite {

		//=============本类属性==============
		////接口元件
		private var scrollText : TextField;
		private var scrollBar_sprite : Sprite;
		private var up_btn : SimpleButton;
		private var down_btn : SimpleButton;
		private var pole_sprite : Sprite;
		private var bg_sprite : Sprite;
		////初始数据
		private var poleStartHeight : Number;
		private var poleStartY : Number;
		private var totalPixels : Number;
		private var isSelect : Boolean;
		////上下滚动按钮按钮下时间
		private var putTime : Number;
		
		/**
		 * @param scrollText_fc:被滚动的文本框
		 * @param scrollBarMc_fc：舞台上与本类所代理的滚动条元件
		 * @param height_fc：滚动条高
		 * @param width_fc：滚动条宽
		 */
		public function ScrollBar(scrollText_fc : TextField, scrollBarMc_fc : Sprite, height_fc : uint = 0,width_fc : uint = 0) {
			//——————滚动条_sprite，滚动条按钮和滑块mc，被滚动的文本域初始化
			scrollText = scrollText_fc;
			scrollBar_sprite = scrollBarMc_fc;
			if(scrollBar_sprite.getChildByName("up_btn")!=null)
			{
				up_btn = SimpleButton(scrollBar_sprite.getChildByName("up_btn"));
				down_btn = SimpleButton(scrollBar_sprite.getChildByName("down_btn"));
				
				up_btn.enabled = false;
				down_btn.enabled = false;
			}
			pole_sprite = Sprite(scrollBar_sprite.getChildByName("pole_mc"));
			bg_sprite = Sprite(scrollBar_sprite.getChildByName("bg_mc"));
			
			//——————可用性控制
			pole_sprite.visible = false;
			
			
			//——————其他属性初始化
			bg_sprite.useHandCursor = false;
			isSelect = scrollText.selectable;
			if(height_fc == 0) {
				bg_sprite.height = scrollText.height;
			}else {
				bg_sprite.height = height_fc;
			}
			if(width_fc != 0) { 
				bg_sprite.width = width_fc+2;
				pole_sprite.width=width_fc;
				up_btn.width = up_btn.height = down_btn.width = down_btn .height = width_fc;	
			}
			down_btn.y = bg_sprite.y + bg_sprite.height - down_btn.height - 1;
			poleStartHeight = Math.floor(down_btn.y - up_btn.y - up_btn.height);
			poleStartY = pole_sprite.y = Math.floor(up_btn.y + up_btn.height);
			
			//——————注册侦听器
			//文本滚动与鼠标滚轮
			scrollText.addEventListener(Event.SCROLL, textScroll);
			scrollText.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			//上滚动按钮
			up_btn.addEventListener(MouseEvent.MOUSE_DOWN, upBtn);
			up_btn.stage.addEventListener(MouseEvent.MOUSE_UP, upBtnUp);
			//下滚动按钮
			down_btn.addEventListener(MouseEvent.MOUSE_DOWN, downBtn);
			down_btn.stage.addEventListener(MouseEvent.MOUSE_UP, downBtnUp);
			//滑块
			pole_sprite.addEventListener(MouseEvent.MOUSE_DOWN, poleSprite);
			pole_sprite.stage.addEventListener(MouseEvent.MOUSE_UP, poleUp);
			//滑块背景点击
			bg_sprite.addEventListener(MouseEvent.MOUSE_DOWN, bgDown);
		}

		/**
		 * 文本滚动事件
		 */
		private function textScroll(event : Event) : void {
			//判断滑块儿是否显示，并根据文本内容多少定义滑块高度
			if(scrollText.maxScrollV != 1) {
				pole_sprite.visible = true;
				up_btn.enabled = true;
				down_btn.enabled = true;
				//定义一个高度因子，此因子随加载文本的增多，将无限趋向于1
				var heightVar : Number = 1 - (scrollText.maxScrollV - 1) / scrollText.maxScrollV;
				//根据高度因子初始化滑块的高度
				pole_sprite.height = Math.floor(poleStartHeight * Math.pow(heightVar, 1 / 3));
				totalPixels = Math.floor(down_btn.y - up_btn.y - up_btn.height - pole_sprite.height);
				pole_sprite.y = Math.floor(poleStartY + totalPixels * (scrollText.scrollV - 1) / (scrollText.maxScrollV - 1));
			}else {
				pole_sprite.visible = false;
				up_btn.enabled = false;
				down_btn.enabled = false;
			}
		}

		/**
		 * 滑块滚动
		 */
		private function poleSprite(event : MouseEvent) : void {
			//首先取消文本框滚动侦听，因为文本滚动的时候会设置滑块的位置，而此时是通过滑块调整文本的位置，所以会产生冲突
			scrollText.removeEventListener(Event.SCROLL, textScroll);
			//监听舞台，这样可以保证拖动滑竿的时候，鼠标在舞台的任意位置松手，都会停止拖动
			scrollBar_sprite.stage.addEventListener(MouseEvent.MOUSE_UP, poleUp);
			//限定拖动范围
			var dragRect : Rectangle = new Rectangle(pole_sprite.x, poleStartY, 0, totalPixels);
			pole_sprite.startDrag(false, dragRect);
			scrollBar_sprite.addEventListener(Event.ENTER_FRAME, poleDown);
		}

		private function poleDown(event : Event) : void {
			//在滚动过程中及时获得滑块所处位置
			var nowPosition : Number = Math.floor(pole_sprite.y);
			//使文本随滚动条滚动,这里为什么要加1，可见scroll属性值应该是取正的，也就是说它会删除小数部分，而非采用四舍五入制？
			scrollText.scrollV = (scrollText.maxScrollV - 1) * (nowPosition - poleStartY) / totalPixels + 2;
			//误差校正
			var unitPixels : Number = totalPixels / (scrollText.maxScrollV - 1);
			if((nowPosition - poleStartY) < unitPixels) {
				scrollText.scrollV = (scrollText.maxScrollV - 1) * (nowPosition - poleStartY) / totalPixels;
			}
		}

		private function poleUp(event : MouseEvent) : void {
			pole_sprite.stopDrag();
			scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, poleDown);
			scrollBar_sprite.stage.removeEventListener(MouseEvent.MOUSE_UP, poleUp);
			scrollText.addEventListener(Event.SCROLL, textScroll);
		}

		/**
		 * 滑块背景点击
		 */
		private function bgDown(event : MouseEvent) : void {	
			var nowPosition : Number;
			if((scrollBar_sprite.mouseY - up_btn.y) < (pole_sprite.height / 2)) {
				nowPosition = Math.floor(up_btn.y + up_btn.height);
			}else if((down_btn.y - scrollBar_sprite.mouseY) < pole_sprite.height / 2) {
				nowPosition = Math.floor(down_btn.y - pole_sprite.height);
			}else {
				nowPosition = scrollBar_sprite.mouseY - pole_sprite.height / 2;
			}
			pole_sprite.y = nowPosition;
			scrollText.scrollV = (scrollText.maxScrollV - 1) * (nowPosition - poleStartY) / totalPixels + 2;
			var unitPixels : Number = totalPixels / (scrollText.maxScrollV - 1);
			if((nowPosition - poleStartY) < unitPixels) {
				scrollText.scrollV = (scrollText.maxScrollV - 1) * (nowPosition - poleStartY) / totalPixels + 1;
			}
		}

		/**
		 * 下滚动按钮
		 */
		private function downBtn(event : MouseEvent) : void {
			scrollText.scrollV++;
			pole_sprite.y = Math.floor(poleStartY + totalPixels * (scrollText.scrollV - 1) / (scrollText.maxScrollV - 1));
			//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			putTime = getTimer();
			scrollBar_sprite.addEventListener(Event.ENTER_FRAME, downBtnDown);	
		}

		private function downBtnDown(event : Event) : void {
			if(getTimer() - putTime > 500) {
				scrollText.scrollV++;
				pole_sprite.y = Math.floor(poleStartY + totalPixels * (scrollText.scrollV - 1) / (scrollText.maxScrollV - 1));
			}
		}	

		private function downBtnUp(event : MouseEvent) : void {
			scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, downBtnDown);
		}

		/**
		 * 上滚动按钮
		 */
		private function upBtn(event : MouseEvent) : void {
			scrollText.scrollV--;
			pole_sprite.y = Math.floor(poleStartY + totalPixels * (scrollText.scrollV - 1) / (scrollText.maxScrollV - 1));
			//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			putTime = getTimer();
			scrollBar_sprite.addEventListener(Event.ENTER_FRAME, upBtnDown);	
		}

		private function upBtnDown(event : Event) : void {
			if(getTimer() - putTime > 500) {
				scrollText.scrollV--;
				pole_sprite.y = Math.floor(poleStartY + totalPixels * (scrollText.scrollV - 1) / (scrollText.maxScrollV - 1));
			}
		}

		private function upBtnUp(event : MouseEvent) : void {
			scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, upBtnDown);
		}

		/**
		 * 鼠标滚轮事件
		 */
		private function mouseWheel(event : MouseEvent) : void {
			if(isSelect == false) {
				scrollText.scrollV -= Math.floor(event.delta / 2);
			}else if(isSelect == true) {
				event.delta = 1;
			}
			pole_sprite.y = Math.floor(poleStartY + totalPixels * (scrollText.scrollV - 1) / (scrollText.maxScrollV - 1));
		}
	}
}