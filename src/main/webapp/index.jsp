<%--
  Created by IntelliJ IDEA.
  User: 当然是选择原谅我哦
  Date: 2020/5/16
  Time: 22:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>员工列表</title>

    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>

    <%--   web路径：
                不以/开始的相对路径，找资源是以当前资源的路径为基准，经常容易出问题
                而以/开始的相对路径，是以服务器的路径为标注的（http://localhost:3306），需要加上项目名
                        http://localhost:3306/crud
       --%>
    <script src="${APP_PATH}/static/js/jquery-3.1.1.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>


</head>
<body>

    <%------------------------------ 员工添加的模态框 ------------------------------%>
    <div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">新增员工</h4>
                </div>
                <div class="modal-body">

                    <%------------------------------ 表单 ------------------------------%>
                    <form class="form-horizontal">
                        <%-- empName --%>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <%-- email --%>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@gmail.com">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <%-- gender --%>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">gender</label>
                            <div class="col-sm-10">
                                <%-- 内联单选 --%>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                                </label>
                            </div>
                        </div>
                        <%-- department --%>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">deptName</label>
                            <div class="col-sm-4">
                                <%-- 下拉列表，部门选项只要提交部门id即可 --%>
                                <select class="form-control" name="dId" id="dept_select"></select>
                            </div>
                        </div>
                    </form>
                    <%----------------------------------------------------------------%>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
                </div>
            </div>
        </div>
    </div>
    <%----------------------------------------------------------------------------%>


    <%------------------------------ 员工修改的模态框 -----------------------------%>
    <div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">员工修改</h4>
                </div>
                <div class="modal-body">

                    <%------------------------------ 表单 ------------------------------%>
                    <form class="form-horizontal">
                        <%-- empName --%>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <p class="form-control-static" id="empName_update_static"></p>
                            </div>
                        </div>
                        <%-- email --%>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@gmail.com">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <%-- gender --%>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">gender</label>
                            <div class="col-sm-10">
                                <%-- 内联单选 --%>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                                </label>
                            </div>
                        </div>
                        <%-- department --%>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">deptName</label>
                            <div class="col-sm-4">
                                <%-- 下拉列表，部门选项只要提交部门id即可 --%>
                                <select class="form-control" name="dId" id="dept_select"></select>
                            </div>
                        </div>
                    </form>
                    <%------------------------------------------------------------------%>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
                </div>
            </div>
        </div>
    </div>
    <%----------------------------------------------------------------------%>


    <%-- 搭建显示页面 --%>
    <div class="container">
        <%-- 标题 --%>
        <div class="row">
            <div class="col-md-12">
                <h1>SSM-CRUD</h1>
            </div>
        </div>

        <div class="row">

            <%--    ------------查找框--------------   --%>
            <div class="col-lg-4">
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="输入员工id或员工姓名" id="search_emp">
                    <span class="input-group-btn">
                        <%-- 查找按钮 --%>
                        <button class="btn btn-primary glyphicon glyphicon-search" type="button" id="search_btn">Search</button>
                    </span>
                </div><!-- /input-group -->
            </div><!-- /.col-lg-6 -->
            <%--    -------------------------------   --%>

            <%-- 新增/删除 按钮 --%>
            <div class="col-md-4 col-md-offset-4">
                <button class="btn btn-info" id="emp_add_modal_btn">新增</button>
                <button class="btn btn-danger" id="emp_delete_batch_btn">删除</button>
            </div>

        </div>

        <%-- 显示表格数据 --%>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover" id="emps_table">
                    <%-- 表头 --%>
                    <thead>
                        <tr>
                            <th>
                                <%-- 一键全选 --%>
                                <input type="checkbox" id="check_all">
                            </th>
                            <th>#</th>
                            <th>empName</th>
                            <th>gender</th>
                            <th>email</th>
                            <th>deptName</th>
                            <th>操作</th>
                        </tr>
                    </thead>

                    <tbody><%-- 员工数据放在tbody里 --%></tbody>

                </table>
            </div>
        </div>

        <%-- 显示分页信息 --%>
        <div class="row">
            <%-- 分页文字信息 --%>
            <div class="col-md-6" id="page_info_area"></div>

            <%-- 分页条信息 --%>
            <div class="col-md-6" id="page_nav_area"></div>
        </div>
    </div>



<%--  =========================================================================================  --%>
<%--  ==========================================js部分=========================================  --%>
<%--  =========================================================================================  --%>



    <script type="text/javascript">
<%--        1、页面加载完成以后，直接发送一个ajax请求，获取分页数据--%>

        <%-- 总记录数，用于跳转到最后一页。
        由于有了分页插件，当跳转页面大于总页面数的时候，就会跳转到最后一页 --%>
        var totalRecordCount;
        //当前页数，用于修改完员工信息之后跳转到本页面。
        var currentPage;


        $(function () {
            //去首页
            to_page(1);

        });

        //实现页面跳转，想跳到第几页就传参数
        function to_page(page) {
            //每次页面跳转时，都将全选/全不选设置为false
            $("#check_all").prop("checked", false);

            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pn=" + page,
                type:"GET",
                success:function (res) {
                    // console.log(res);
                    // 1、解析并显示员工数据
                    build_emps_table(res);
                    // 2、解析并显示分页信息
                    build_page_info(res);
                    // 3、解析并显示分页条
                    build_page_nav(res);
                }
            });
        }

        // 1、解析并显示员工数据
        function build_emps_table(res) {
            //清空table表格，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $("#emps_table tbody").empty();

            //获取所有员工数据
            var emps = res.extend.pageInfo.list;

            //遍历员工数据
            $.each(emps, function (index, item) {
                //在员工数据的最左边加上多选框
                var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");

                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
                var emailTd = $("<td></td>").append(item.email);
                var deptNameTd = $("<td></td>").append(item.department.deptName);

                //编辑按钮
                var editBtn = $("<button></button>").addClass("btn btn-info btn-sm edit_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑"));
                //为编辑按钮添加一个自定义的属性，来表示当前员工id
                editBtn.attr("edit-id", item.empId);

                //删除按钮
                var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash").append("删除"));
                //为删除按钮添加一个自定义的属性，来表示当前员工id
                delBtn.attr("del-id", item.empId);

                //把两个按钮放到一个单元格中，并且按钮之间留点空隙
                var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);

                //append方法执行完成以后还是会返回原来的元素，所以可以一直.append添加元素，
                //将上面的td添加到同一个tr里
                $("<tr></tr>").append(checkBoxTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    .appendTo("#emps_table tbody");//将tr添加到tbody标签中
            });

        }

        // 2、解析并显示分页条
        function build_page_nav(res) {
            //清空分页条，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $("#page_nav_area").empty();

            var ul = $("<ul></ul>").addClass("pagination");



            //构建首页和上一页的标签
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
            //如果没有上一页，就设置首页和上一页的按钮不可用
            if(res.extend.pageInfo.hasPreviousPage == false){
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            }else{
                //如果有上一页，才绑定单击事件
                //为首页标签添加单击事件
                firstPageLi.click(function () {
                    to_page(1);
                });
                //为上一页标签添加单击事件
                prePageLi.click(function () {
                    to_page(res.extend.pageInfo.pageNum - 1);
                });
            }


            //下一页和尾页
            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
            var lastPageLi = $("<li></li>").append($("<a></a>").append("尾页").attr("href","#"));
            //如果没有下一页，就设置下一页和尾页按钮不可用
            if(res.extend.pageInfo.hasNextPage == false){
                nextPageLi.addClass("disabled");
                lastPageLi.addClass("disabled");
            }else{
                //如果有下一页，才绑定单击事件
                //为下一页标签添加单击事件
                nextPageLi.click(function () {
                    to_page(res.extend.pageInfo.pageNum + 1);
                });
                //为尾页标签添加单击事件
                lastPageLi.click(function () {
                    to_page(res.extend.pageInfo.pages);
                });
            }


            //添加首页和前一页到ul标签中
            ul.append(firstPageLi).append(prePageLi);

            //遍历，给ul中添加页码
            $.each(res.extend.pageInfo.navigatepageNums, function (index, item) {

                var numLi = $("<li></li>").append($("<a></a>").append(item));

                //绑定单击事件，点击页码进行跳转
                numLi.click(function () {
                    to_page(item);
                })

                //当前页数高亮显示
                if(res.extend.pageInfo.pageNum == item){
                    numLi.addClass("active");
                }

                ul.append(numLi);
            })

            //添加下一页和尾页到ul标签中
            ul.append(nextPageLi).append(lastPageLi);

            //把ul添加到nav标签中
            var navEle = $("<nav></nav>").append(ul).appendTo("#page_nav_area");

        }

        // 3、解析并显示分页文字信息
        function build_page_info(res) {
            //清空分页文字信息，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $("#page_info_area").empty();

            $("#page_info_area").append("当前第" + res.extend.pageInfo.pageNum + "/" +
                                                    res.extend.pageInfo.pages + "页，共" +
                                                    res.extend.pageInfo.total +"条记录。");

            // 赋值总记录数，方便后面调用
            totalRecordCount = res.extend.pageInfo.total;
            //赋值当前页数，方便后面调用
            currentPage = res.extend.pageInfo.pageNum;
        }

//==========================================================================================

        //清空表单样式及内容
        function reset_form(ele){
            //清空表单内容，取出dom对象，调用reset()方法
            $(ele)[0].reset();
            //清空表单样式
            $(ele).find("*").removeClass("has-error has-success");
            //清空提示信息
            $(ele).find(".help-block").text("");
        }


    //点击新增按钮，弹出模态框
        $("#emp_add_modal_btn").click(function () {
            //清除表单数据（表单重置，包括表单数据以及表单样式），防止出现点击保存之后再次点击新增，跳出的模态框还是保存上次添加的记录，避免重复添加。
            //取出dom对象，调用reset()方法
            // $("#empAddModal form")[0].reset();
            reset_form("#empAddModal form");

            //发送ajax请求，在弹出模态框之前查询部门信息，显示在下拉列表中
            getDepts("#empAddModal select");

            //弹出模态框
            $("#empAddModal").modal({
                backdrop:"static"
            });
        });

        //查出所有部门信息并显示在下拉列表中
        function getDepts(ele) {
            //清空下拉菜单信息，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $(ele).empty();

            $.ajax({
                url:"${APP_PATH}/depts",
                type:"GET",
                success:function (res) {
                    // 点击添加后，最终返回的json字符串是这样的
                    // {"code":100,"msg":"处理成功!",
                    //     "extend":{"depts":[{"deptId":1,"deptName":"开发部"},{"deptId":2,"deptName":"测试部"}]}}

                    //遍历部门信息，在下拉列表中显示部门信息
                    $.each(res.extend.depts, function () {
                        //在遍历之前
                        var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);

                        //将option标签添加到empAddModal下的select标签中
                        //传入ele参数，调用时只需把对应id作为参数即可
                        optionEle.appendTo(ele);

                        //将option标签添加到empUpdateModal下的select标签中，用于编辑的模态框
                        // optionEle.appendTo("#empUpdateModal select");
                    });
                }
            });
        }

//==========================================================================================

        //这里将校验结果的提示信息全部抽取出来
        function show_validate_msg(ele, status, msg) {
            // 当一开始输入不正确的用户名之后，会变红。
            // 但是之后输入了正确的用户名却不会变绿，
            // 因为has-error和has-success状态叠加了。
            // 所以每次校验的时候都要清除当前元素的校验状态。
            $(ele).parent().removeClass("has-success has-error");
            //提示信息默认为空
            $(ele).next("span").text("");

            if("success" == status){
                //如果校验成功
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);
            }else if("error" == status){
                //如果校验失败
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);
            }
        }


        //校验方法，判断用户名是否重复或者不可用
        function validate_add_form(){

            // $("#empName_add_input").parent().removeClass("has-success has-error");
            // $("#empName_add_input").next("span").text("");
            // $("#email_add_input").parent().removeClass("has-success has-error");
            // $("#email_add_input").next("span").text("");

            // 拿到要校验的数据，使用正则表达式
            var empName = $("#empName_add_input").val();
            //允许数字字母以及_-，6-16位或者中文2-5位
            var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
            //1、校验用户名
            if(!regName.test(empName)){
                //失败
                // alert("用户名必须是6-16位数字，字母或者_-，也可以是2-5位中文组成");
                //添加错误样式到输入框
                // $("#empName_add_input").parent().addClass("has-error");
                //给empName_add_input所在标签的下一个span标签加上文本
                // $("#empName_add_input").next("span").text("用户名必须是6-16位数字，字母或者_-，也可以是2-5位中文组成");

                show_validate_msg("#empName_add_input", "error", "用户名必须是6-16位数字，字母或者_-，也可以是2-5位中文组成");
                return false;
            }else{
                //成功
                // $("#empName_add_input").parent().addClass("has-success");
                // $("#empName_add_input").next("span").text("");
                // console.log("1");

                show_validate_msg("#empName_add_input", "success", "");
            }

            //2、校验邮箱
            var email = $("#email_add_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if(!regEmail.test(email)){
                // alert("邮箱格式不正确!");
                // $("#email_add_input").parent().addClass("has-error");
                // $("#email_add_input").next("span").text("邮箱格式不正确!");

                show_validate_msg("#email_add_input", "error", "邮箱格式不正确!");
                return false;
            }else{
                // $("#email_add_input").parent().addClass("has-success");
                // $("#email_add_input").next("span").text("");

                show_validate_msg("#email_add_input", "success", "");
            }

            return true;
        }



        //设置email的校验状态
        var emailStatus;

        //校验邮箱是否可用
        $("#email_add_input").change(function () {
            if(!validate_add_form()){
                show_validate_msg("#email_add_input", "error", "邮箱格式错误");
                emailStatus = false;
            }else{
                show_validate_msg("#email_add_input", "success","");
                emailStatus = true;
            }
        })

        //校验用户名是否可用
        $("#empName_add_input").change(function () {
        //    发送ajax请求校验用户名是否可用
        //  输入框中的值
            var empName = this.value;

            $.ajax({
                url:"${APP_PATH}/checkuser",
                data:"empName=" + empName,
                type:"POST",
                success:function (res) {
                    if(res.code == 100){
                    //成功
                        show_validate_msg("#empName_add_input", "success", "用户名可用");
                    //    如果用户名可用，将success标志保存到ajax-value属性中
                        $("#emp_save_btn").attr("ajax-value", "success");
                    }else{
                    //失败
                        show_validate_msg("#empName_add_input", "error", res.extend.va_msg);
                    //    如果用户名不可用，将error标志保存到ajax-value属性中
                        $("#emp_save_btn").attr("ajax-value", "error");
                    }
                }
            })
        })


        $("#emp_save_btn").click(function () {
        //1、模态框中填写的表单数据提交给服务器进行保存
        //2、先对要提交给服务器的数据进行校验，并且判断之前的ajax用户名校验是否成功
        //    只要有一个校验失败，就无法保存
            if($(this).attr("ajax-value") == "error"){
                return false;
            }

            if(!validate_add_form() || !emailStatus){
                return false;
            }


        //3、校验之后，再发送ajax请求保存员工
        //     alert($("#empAddModal form").serialize());
            $.ajax({
                url:"${APP_PATH}/emp",
                type:"POST",
                data:$("#empAddModal form").serialize(),
                success:function (res) {
                    // alert(res.msg);

                    //判断状态码，如果是100（成功），才关闭模态框并进行跳转
                    if(res.code == 100){
                        // 员工保存陈宫之后，
                        //  1、关闭模态框
                        $('#empAddModal').modal('hide');

                        //  2、跳转到最后一页，显示刚才保存的数据
                        //   由于有了分页插件，当跳转的页面大于总页面数的时候，就会跳转到最后一页
                        to_page(totalRecordCount);
                    }else {
                        //显示失败信息
                        // console.log(res);
                        //有哪个字段的错误信息就显示哪个字段的

                        //如果邮箱有误
                        if (res.extend.errorField.email != undefined){
                        //    显示邮箱错误信息
                            show_validate_msg("#email_add_input", "error", res.extend.errorField.email);
                        }
                        //如果用户名有误
                        if(res.extend.errorField.empName != undefined){
                            //显示用户名错误信息
                            show_validate_msg("#empName_add_input", "error", res.extend.errorField.empName);
                        }

                    }
                }
            });
        });


//=============================================================================

        //为每个员工的编辑按钮绑定单击事件
        //但是，这里的单击事件是在编辑按钮被创建出来之前就已经开始绑定了，所以这里无法绑定单击事件
        //有两种办法
        //     1）可以在创建按钮的时候就给他绑定单击事件
        //     2）绑定单击.live()，而新版jQuery没有live方法，而是用on进行替代
        $(document).on("click", ".edit_btn", function () {
            // alert("edit");
            //1、通过edit-id属性查出员工信息，显示员工信息
            getEmp($(this).attr("edit-id"));

            //2、查出部门信息，并显示部门列表
            getDepts("#empUpdateModal select");

            //弹出模态框，
            //把员工的id传递给模态框的更新按钮，方便点击修改后获取员工id
            $("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));
            $("#empUpdateModal").modal({
                backdrop:"static"
            });
        })

        //员工姓名回显
        function getEmp(id) {
            $.ajax({
                url:"${APP_PATH}/emp/" + id,
                type:"GET",
                success:function (res) {
                    // console.log(res);
                    //获取员工数据
                    var empData = res.extend.emp;
                    //添加到标签文本中
                    $("#empName_update_static").text(empData.empName);
                    //显示邮箱
                    $("#email_update_input").val(empData.email);
                    //选中性别单选框
                    $("#empUpdateModal input[name = gender]").val([empData.gender]);
                    //选中部门
                    $("#empUpdateModal select").val([empData.dId]);

                }
            });
        }


        //修改员工时，校验邮箱是否可用
        $("#email_update_input").change(function () {
            validate_update_email();
        })

        function validate_update_email(){
            var email = $("#email_update_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if(!regEmail.test(email)){
                show_validate_msg("#email_update_input", "error", "邮箱格式不正确!");
                return false;
            }else{
                show_validate_msg("#email_update_input", "success", "");
            }
            return true;
        }

    //    点击更新，更新员工信息
        $("#emp_update_btn").click(function () {

            //验证邮箱是否合法
            var email = $("#email_update_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if(!regEmail.test(email)){
                show_validate_msg("#email_update_input", "error", "邮箱格式不正确!");
                return false;
            }else{
                show_validate_msg("#email_update_input", "success", "");
            }

            //发送ajax请求保存更新的员工数据
            $.ajax({
                //加上之前在修改按钮上保存的edit-id的值
                url:"${APP_PATH}/emp/" + $(this).attr("edit-id"),
                type:"PUT",
                data:$("#empUpdateModal form").serialize(),// + "&_method=PUT",
                success:function (res) {
                    // alert(res.msg);
                    //关闭对话框
                    $('#empUpdateModal').modal('hide');

                    //回到本页面
                    to_page(currentPage);

                }
            })
        })


        //单个删除
        $(document).on("click", ".delete_btn", function () {
        //    弹出是否删除确认框，并显示员工姓名
        //    找tr标签下的第三个td标签，对应的就是员工名字
            var empName = $(this).parents("tr").find("td:eq(2)").text();

            //拿到当前员工的id
            var empId = $(this).attr("del-id");

            //弹出确认框，点击确认就删除
            if(confirm("确认删除 [" + empName + "] 吗？")){
            //    确认，发送ajax请求删除
                $.ajax({
                    url:"${APP_PATH}/emp/" + empId,
                    type:"DELETE",
                    success:function (res) {
                        alert(res.msg);

                        //回到本页
                        to_page(currentPage);
                    }
                })
            }
        });


    //    完成全选/全不选功能
        $("#check_all").click(function () {
        //   attr获取checked是undefined，因为我们没有定义checked属性，attr获取的是自定义属性值
        //    而我们这些dom原生的属性，可以用prop来获取这些值
        //     alert($(this).prop("checked"));
        //    让所有复选框状态同步
            $(".check_item").prop("checked", $(this).prop("checked"));
        });

    //    当本页面所有复选框都选上时，自动将全选复选框选上
        $(document).on("click", ".check_item", function () {
            //判断当前选择中的元素是否是当前页面所有check_item的个数
            var flag = $(".check_item:checked").length == $(".check_item").length;

            $("#check_all").prop("checked", flag);
        })


    //    为批量删除绑定单击事件
        $("#emp_delete_batch_btn").click(function () {

            var empNames = "";
            var del_idstr = "";

            //遍历每一个被选中的复选框
            $.each($(".check_item:checked"), function () {
                // 获取要删除的员工姓名
                empNames += $(this).parents("tr").find("td:eq(2)").text() + "\n";

                //获取要删除的员工的id
                del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
            });

            //去除多余的-
            del_idstr = del_idstr.substring(0, del_idstr.length - 1);

            if(confirm("确认删除 \n" + empNames + " 吗？")){
                $.ajax({
                    url:"${APP_PATH}/emp/" + del_idstr,
                    type:"DELETE",
                    success:function (res) {
                        alert(res.msg);
                        to_page(currentPage);
                    }
                })
            }

        });




//=====================================查询===============================================

        //为搜索按钮绑定单击事件
        $("#search_btn").click(function () {
            //清空tbody，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $("#emps_table tbody").empty();

            //将搜索框中的内容保存到searchContent中
            var searchContent = $("#search_emp").val();

            console.log(searchContent);

            $("#page_nav_area").empty();

            //如果输入框中的内容为空的话，用to_page回到原本显示的界面。
            if(searchContent == ""){
                to_page(1);
            }else{
                //如果不为空的话，发送ajax请求
                $.ajax({
                    url:"${APP_PATH}/empSearch",
                    type:"GET",
                    data:"content=" + searchContent,
                    success:function (res) {

                        //显示搜索到的员工
                        search_emps_table(res);
                        //显示搜索页面的分页信息
                        build_search_page_info(res);
                    }
                });
            }
        })

        // 解析并显示查询到的员工数据
        function search_emps_table(res) {
            //清空table表格，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $("#emps_table tbody").empty();

            //将查找出来的员工数据保存在empSearched中
            var empSearched = res.extend.pageInfo.list;

            //如果empSearch中的数据为空的话，就提示未找到
            if(empSearched.length == 0){
                $("<h5></h5>").append("").append("NOT FOUND")
                    .appendTo("#emps_table tbody");//将tr添加到tbody标签中
            }else {

                //遍历所有查询到的员工
                $.each(empSearched, function (i, val) {
                    //在员工数据的最左边加上多选框
                    var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");

                    var empIdTd = $("<td></td>").append(empSearched[i].empId);
                    var empNameTd = $("<td></td>").append(empSearched[i].empName);
                    var genderTd = $("<td></td>").append(empSearched[i].gender == 'M' ? "男" : "女");
                    var emailTd = $("<td></td>").append(empSearched[i].email);
                    var deptNameTd = $("<td></td>").append(empSearched[i].department.deptName);

                    //编辑按钮
                    var editBtn = $("<button></button>").addClass("btn btn-info btn-sm edit_btn")
                        .append($("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑"));
                    //为编辑按钮添加一个自定义的属性，来表示当前员工id
                    editBtn.attr("edit-id", empSearched[i].empId);

                    //删除按钮
                    var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                        .append($("<span></span>").addClass("glyphicon glyphicon-trash").append("删除"));
                    //为删除按钮添加一个自定义的属性，来表示当前员工id
                    delBtn.attr("del-id", empSearched[i].empId);

                    //把两个按钮放到一个单元格中，并且按钮之间留点空隙
                    var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);

                    //append方法执行完成以后还是会返回原来的元素，所以可以一直.append添加元素，
                    //将上面的td添加到同一个tr里
                    $("<tr></tr>").append(checkBoxTd)
                        .append(empIdTd)
                        .append(empNameTd)
                        .append(genderTd)
                        .append(emailTd)
                        .append(deptNameTd)
                        .append(btnTd)
                        .appendTo("#emps_table tbody");//将tr添加到tbody标签中
                })
            }
        }

        // 解析并显示搜索页面的分页信息
        function build_search_page_info(res) {
            //清空分页文字信息，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $("#page_info_area").empty();
            //显示共几条记录
            $("#page_info_area").append("已查询到" + res.extend.pageInfo.total +"条记录。");

        }


    </script>
</body>
</html>
