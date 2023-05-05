# 网络应用开发课程设计
学号：202030443226
姓名：颜智泳

    设计上主要考虑三个主界面：main.jsp（买家和卖家公用）、customers.jsp（买家个人主页）和merchants（卖家个人主页）。
    main.jsp：左上角有“个人主页”、“注销”和商家才能看到的“商家三大功能”。右上角有“搜索框”。主体是商品信息的瀑流式展览，每个商品下方有“添加至购物车”的按钮（商家不可见）。
    customers.jsp：左上角不变，额外多一个“返回主页”。主体包括一个购物车界面和已购信息展览界面。
    merchants.jsp: 左上角同上，主体包括信息通界面（即买家购买商品后对商家的通知，商家点击“已发货”则表示该通知被处理了）和其所登记商品的数据统计界面。
    admin.jsp:左上角仅为返回主页，主体包括账号信息和商品的销售信息，此界面用于监测，具体修改设置需要进入服务器后台作修改。登录页面设置了token，仅对单次登录起效，无Cookie设置使得登录效果不会保存。
    此外还有注册页面register.jsp，登录页面login.jsp，搜索页面search.jsp和商家的三大功能：商品上传页面product_upload.jsp、商品管理页面product_manage.jsp和商品贸易记录页面product_trade_show.jsp。
    此外的jsp，包括命名格式为小写_大写，末尾以temp或flash结尾的jsp，均为跳板，主要用于接受页面的数据、传递给数据库然后返回页面，或者爬取数据库的数据后传递给页面。
    logout_temp.jsp：清空缓存，通过清空记录用户登录信息的Cookie实现注销，清空后返回login.jsp。其与login.jsp共同生效记录用户的登入、登出时相关的IP信息和时间点，用于大数据分析。
    product_insert_temp.jsp：接收上传页面通过表单-POST的方式传来的值，然后调用src的JAVA文件“ProductUploadServlet”来实现数据库中的插入（其实这个JAVA文件与Servlet关系不大）。然后返回main.jsp。
    product_delete_temp.jsp: 接收管理页面通过表单-POST的方式传来的值，然后直接连接数据库根据获得的值（该值为商品id，具有唯一性），直接进行商品下架，然后返回product_manage.jsp
    product_manage_flash.jsp： 在管理页面存在选择滚动条，商家可以选择其已经登记的未下架的商品进行修改，当选定商品后商品会将商品id通过表单-POST提交给该jsp，然后其配合数据库搜索将相关信息发回原页面，实现商品信息框的填充，利于商品信息修改。
    updateProduct.jsp: 接收管理页面通过表单-POST的方式传来的值，然后直接连接数据库根据获得的值对商品信息进行修改，然后返回product_manage.jsp。
    updateQuantity.jsp: 买家购物车中的商品的数量是可更替的，通过该jsp实现购物车中所选商品数量的改变，然后返回customers.jsp。
    role_choose_temp.jsp：用户点击左上方个人信息后，根据用户类型判断返回customers.jsp还是merchants.jsp。
    sale_prediction.jsp：在数据报表网页上（基于已购数据表）的拓展功能，用于分析某一商品（由商品id确定唯一性）的近期售况和总售况，用于分析商品的未来销售情况
    data_record.jsp：针对销售方而言，可以手动保存该次登录的操作，记录为操作日志，可设置为登出后自动执行。
    user_analysis.jsp：尚未完全实现，实现基础在于给商品标签化，然后根据商品的标签化给已经购入商品的用户进行标签化，实现用户画像的确立，并通过双方的标签联系建立商品推荐系统。
    另外src配置了几个.java文件，其中Servlet类型有AddToCart，BuyItem，CheckDelivery，DeleteItem和LoginServlet。信息传递方式全是通过重写doPOST。
    AddToCart：针对点击“添加至购物车”作反应，将指定商品的商品id和用户名绑定起来，初始量为1，每点一次加1，记录于数据库中的“购物车”表中。
    BuyItem：针对在购物车中点击“购买”作反应，将该购买数据记录在数据库中的“已购数据”表中   
    CheckDelivery：针对在购物车更新数量，通过搜索“商品信息”表，判断商品预计购买数是否不大于库存。
    DeleteItem：删除购物车上某一商品。
    LoginServlet：用于登录时与数据库中“账号数据”表做匹配：（1）账号是否存在（2）账号密码是否匹配（3）匹配后返回账户类型。
    Record：在Login和Logout中使用，用于记录用户IP和操作时间
    另外有InsertAccount和SelectRegister：后者用于判断注册时填写的用户名、邮箱有无重复，后者用于把可注册的数据填入数据库。
    各jsp和各java文件大体作用如上，还有一些其他代码譬如：Cookies实现用户登录状态在个页面的传递、<script>中定义function搭配表单的onclick来检测表单中输入的数据格式是否正确、其余大数据信息记录以及对所记录数据进行分析等。
