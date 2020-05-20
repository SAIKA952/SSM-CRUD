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
<%--搭建显示页面--%>
    <div class="container">
<%--    标题--%>
        <div class="row">
            <div class="col-md-12">
                <h1>SSM-CRUD</h1>
            </div>
        </div>

<%--    新增/删除 按钮--%>
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-info">新增</button>
                <button class="btn btn-danger">删除</button>
            </div>
        </div>

<%--    显示表格数据--%>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover">
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>

                    <c:forEach items="${pageInfo.list}" var="emp">
                        <tr>
                            <th>${emp.empId}</th>
                            <th>${emp.empName}</th>
                            <th>${emp.gender == "M" ? "男" : "女"}</th>
                            <th>${emp.email}</th>
                            <th>${emp.department.deptName}</th>
                            <th>
                                <button class="btn btn-info btn-sm">
                                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                    编辑
                                </button>
                                <button class="btn btn-danger btn-sm">
                                    <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                    删除
                                </button>
                            </th>
                        </tr>
                    </c:forEach>

                </table>
            </div>
        </div>

<%--    显示分页信息--%>
        <div class="row">
<%--            分页文字信息--%>
            <div class="col-md-6">
                当前第${pageInfo.getPageNum()}/${pageInfo.getPages()}页，共${pageInfo.getTotal()}条记录。
            </div>

<%--            分页条信息--%>
            <div class="col-md-6">

                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li><a href="${APP_PATH}/emps?pn=1">首页</a></li>

<%--                        判断是否有上一页（是否是第一页），如果是，则不显示该标签，如果不是，点击可以跳转到上一页--%>
                        <c:if test="${pageInfo.hasPreviousPage}">
                            <li>
                                <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>

<%--                        循环遍历分页条--%>
                        <c:forEach items="${pageInfo.navigatepageNums}" var="page_num">
<%--                            判断页码是否等于当前页码，如果等于就让他高亮显示，并且点击无效--%>
                            <c:if test="${page_num == pageInfo.pageNum}">
                                <li class="active"><a href="#">${page_num}</a></li>
                            </c:if>
<%--                            如果不等于就正常显示，点击可以正常跳转--%>
                            <c:if test="${page_num != pageInfo.pageNum}">
<%--                               href="${APP_PATH}/emps?pn=${page_num}跳转到点击的页码 --%>
                                <li><a href="${APP_PATH}/emps?pn=${page_num}">${page_num}</a></li>
                            </c:if>
                        </c:forEach>

<%--                        判断是否有下一页（是否是最后一页），如果是，则不显示该标签，如果不是，点击可以跳转到下一页--%>
                        <c:if test="${pageInfo.hasNextPage}">
                            <li>
                                <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum + 1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>

                        <li><a href="${APP_PATH}/emps?pn=${pageInfo.pages}">尾页</a></li>
                    </ul>
                </nav>

            </div>
        </div>
    </div>

</body>
</html>
