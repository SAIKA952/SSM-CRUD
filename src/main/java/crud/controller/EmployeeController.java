package crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import crud.bean.DepartmentExample;
import crud.bean.Employee;
import crud.bean.EmployeeExample;
import crud.bean.Msg;
import crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工CRUD请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;


    /**
     *  查询功能
     *  可以根据搜索框（content）中的内容查询与之有关的员工，包括员工姓名，员工id。
     */
    @ResponseBody
    @RequestMapping("/empSearch")
    public Msg searchEmpsByVague(@RequestParam("content") String content){

//        引入pageHelper分页查询，
//        在查询之前只需要调用PageHelper.startPage()，传入页码，以及每一页显示的数量
        PageHelper.startPage(1, 1000000);
//        分页完之后的查询就是分页查询

//        模糊查询，姓名中包含content的或者id为content的都会被搜索出来
        List<Employee> employees = employeeService.getEmpByVague(content);

        System.out.println(employees);
//        分页查询完之后，可以使用pageInfo来包装查询后的结果，
//        只需要将pageInfo交给页面就行
//        pageInfo封装了详细的分页信息，包括我们查询出来的数据
//        比如总共有多少页，当前是第几页等。。。
//        想要连续显示5页，就加上参数5即可
        PageInfo pageInfo = new PageInfo(employees,5);

        return Msg.success().add("pageInfo", pageInfo);
    }


    /**
     * 按照员工id删除
     * 单个删除和批量删除二合一
     * 如果是批量删除，每个id之间用-分隔开
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("ids") String ids){
//        如果包含-就是批量删除
        if(ids.contains("-")){
//            批量删除

            List<Integer> del_ids = new ArrayList<>();
//            按照-分隔开，转化为String数组
            String[] str_ids = ids.split("-");

//            组装id的集合
            for(String s : str_ids){
                del_ids.add(Integer.parseInt(s));
            }
            employeeService.deleteBatch(del_ids);
        }else{
//            单个删除
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }


    /**
     * 如果ajax直接发送PUT请求，我们封装的数据为：
     * Employee
     *      {empId=1036, empName='null', gender='null', email='null', dId=null, department=null}
     * 而在请求头中是有数据的，email=ast12123%40nn.com&gender=M&dId=1
     *
     * 问题就在于请求体中有数据，但是Employee对象封装不上
     * 这样的话SQL语句就变成 update tbl_employee where emp_id = 1014 ，没有set字段，所以sql语法就有问题
     *
     * 而封装不上的原因在于
     * Tomcat:
     *      tomcat会将请求体中的数据封装为一个map，request.getParameter("empName")就会从这个map中取值
     *      而SpringMVC封装POJO对象的时候，会把POJO中每个属性的值调用request.getParameter()方法来获取
     *
     *      但是如果AJAX发送PUT请求，tomcat看到是PUT请求，就不会将请求体中的数据封装为map，
     *      只有POST请求才会封装请求体为map
     *
     *解决方案：
     * 我们要能支持直接发送PUT之类的请求，还要封装请求体中的数据
     *      在web.xml中配置上HttpPutFormContentFilter过滤器
     *      他的作用是将请求体中的数据解析包装成map
     *      request被重新包装，request.getParameter()被重写，就会从自己封装的map中取出数据
     *
     * 员工更新方法
     * @param employee
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    public Msg updateEmp(Employee employee, HttpServletRequest request){
//        System.out.println("请求体中的gender值：" + request.getParameter("gender"));
        System.out.println("将要更新的员工数据：" + employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }



    /**
     * 根据id查询员工
     * @param id
     * @return
     */
//    @PathVariable 从路径中取出id
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp", employee);
    }



    /**
     * 检查用户名是否可用
     * @param empName
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/checkuser")
    public Msg checkuser(@RequestParam("empName") String empName){
//        先判断用户名是否是合法的表达式，再判断是否重复
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if(!empName.matches(regx)){
            return Msg.fail().add("va_msg", "用户名必须是6-16位数字，字母或者_-，也可以是2-5位中文组成");
        }else{
//            数据库用户名重复校验
            boolean b = employeeService.checkUser(empName);
            if(b){
                return Msg.success();
            }else{
                return Msg.fail().add("va_msg", "用户名已存在");
            }
        }

    }


    /**
     * 如果uri为 /emp/{id} ，请求方式为GET，就查询员工
     * 如果uri为 /emp ，     请求方式为POST，就保存员工
     * 如果uri为 /emp/{id} ，请求方式为PUT，就修改员工
     * 如果uri为 /emp/{id} ，请求方式为DELETE，就删除员工
     */
    /**
     * 保存员工
     * 要支持JSR303，需要导入Hibernate-Validator包
     *
     * @Valid :封装对象之后，对数据进行校验
     * BindingResult :封装校验的结果
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
//            校验失败，在模态框中显示校验失败的错误信息

            Map<String, Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for(FieldError fieldError : errors){
                System.out.println("错误的字段名：" + fieldError.getField());
                System.out.println("错误信息：" + fieldError.getDefaultMessage());
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
//            把错误信息返回给浏览器
            return Msg.fail().add("errorField", map);
        }else{
//            校验成功
            employeeService.saveEmp(employee);
            return Msg.success();
        }

    }


    /**
     *  返回json数据
     * .@ResponseBody要能正常工作，需要导入jackson包
     */
    @ResponseBody
    @RequestMapping("/emps")
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn){

//        引入pageHelper分页查询，
//        在查询之前只需要调用PageHelper.startPage()，传入页码，以及每一页显示的数量
        PageHelper.startPage(pn,10);
//        分页完之后的查询就是分页查询
        List<Employee> emps = employeeService.getAll();

//        分页查询完之后，可以使用pageInfo来包装查询后的结果，
//        只需要将pageInfo交给页面就行
//        pageInfo封装了详细的分页信息，包括我们查询出来的数据
//        比如总共有多少页，当前是第几页等。。。
//        想要连续显示5页，就加上参数5即可
        PageInfo pageInfo = new PageInfo(emps,5);
        return Msg.success().add("pageInfo", pageInfo);
    }


    /**
     * 查询员工数据（分页查询）
     * @return
     */
//    @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){

//        引入pageHelper分页查询，
//        在查询之前只需要调用PageHelper.startPage()，传入页码，以及每一页显示的数量
        PageHelper.startPage(pn,5);
//        分页完之后的查询就是分页查询
        List<Employee> emps = employeeService.getAll();

//        分页查询完之后，可以使用pageInfo来包装查询后的结果，
//        只需要将pageInfo交给页面就行
//        pageInfo封装了详细的分页信息，包括我们查询出来的数据
//        比如总共有多少页，当前是第几页等。。。
//        想要连续显示5页，就加上参数5即可
        PageInfo pageInfo = new PageInfo(emps,5);
        model.addAttribute("pageInfo",pageInfo);
        return "list";
    }

}
