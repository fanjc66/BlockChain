<template>
	<div class="head-bar" :class="{auto:size}">
		<div class="left">
			<slot name="left">
				<van-icon name="arrow-left" @click="goBack" size="22px"/>
			</slot>
		</div>
		{{title}}
		<div class="right">
			<slot name="right">
			</slot>
		</div>

	</div>
</template>

<script>
	export default {
		name: "head-bar",
		props: {
			title: String, // 标题
			size: Boolean, // 标题
		},
		data() {
			return {
				isBack:false
			}
		},
		methods:{
			goBack(){
				this.$router.back()//返回上一层
			},
		}
	}
</script>

<style lang="less" scoped>
	.head-bar{
		width: 750px;
		height: 96px;
		background: linear-gradient(180deg, #234481 0%, #44ABFA 100%);
		
		font-size: 32px;
		font-family: AlibabaPuHuiTiR;
		color: #FFFFFF;
		line-height: 96px;
		z-index: 18;
		position: fixed;
		display: fixed;
		align-items: center;
		justify-content: center;
		top: 0;
		left: 0;

		.left{		
			position: absolute;
			left: 21px;
			top: 13px;
		}
		.right{
			position: absolute;
			right: 20px;
			font-size:28px;
			font-family:PingFangSC-Regular,PingFang SC;
			font-weight:400;
			color:rgba(1,122,255,1);
			line-height:40px;
		}
	}
	.auto{
		height:100px;
		line-height: 100px;
	}
</style>
