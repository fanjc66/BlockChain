<template>
  <div class="main">
    <head-bar title="设置"></head-bar>

    <div class="about-app">
      <div class="item" v-for="item in tipList">
        {{item.title}}
      </div>
      <div class="item">
        <span>版本</span>
        <span class="edition">V1.0.0</span>
      </div>
    </div>
    <button class="btn" @click="quitUser">退出账号</button>
  </div>
</template>

<script>
    import headBar from '@/components/header/head-bar'
    import { Dialog } from 'vant'
  export default {
      components: {
          headBar,
          [Dialog.Component.name]:Dialog.Component,
      },
    data() {
      return {
        tipList:[
          {
            title:'帮助与反馈'
          },
          {
            title:'信息提醒'
          },
        ]
      }
    },
    created(){
    },
    methods: {
      quitUser(){this.$dialog.confirm({
            title: '提示',
            message: '您确定退出账户吗？',
            })
            .then(() => {
                this.$router.push({name:'登录'})
            })
            .catch(() => {
                console.log('取消')
            })
        }
    }
  }
</script>


<style lang="less" scoped>
  .main {
    background-color: #f8f9fb;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    .about-app{
      margin-top: 100px;
      width:670px;
      height: 300px;
      background:rgba(255,255,255,1);
      box-shadow:10px 16px 16px 0px rgba(0,0,0,0.04);
      border-radius:20px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      .item{
        height: 78px;
        line-height: 78px;
        font-size:28px;
        font-weight:400;
        color:rgba(51,51,51,1);
        text-align: left;
        padding: 0 32px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        .edition{
          height:36px;
          font-size:28px;
          font-family:PingFangSC-Regular;
          font-weight:400;
          color:rgba(102,102,102,1);
          line-height:36px;
          display: flex;
          align-items: center;
        }
      }
    }
    .btn{
      margin: 40px auto;
      width:100%;
      height:96px;
      line-height: 96px;
      background:rgba(255,255,255,1);
      border-radius:20px;
      border: none;
      font-size:28px;
      font-family:PingFangSC-Regular;
      font-weight:400;
      color:rgba(0,145,255,1);
    }
  }
</style>
