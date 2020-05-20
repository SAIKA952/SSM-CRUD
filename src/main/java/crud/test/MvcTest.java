package crud.test;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;
import crud.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * 使用Spring测试模块提供的测试请求功能，测试crud请求的正确性
 * Spring4测试的时候，需要servlet3.0的支持
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml","file:src/main/webapp/WEB-INF/dispatcher-servlet.xml"})
public class MvcTest {

//    传入SpringMVC的ioc
    @Autowired
    WebApplicationContext context;

//    虚拟mvc请求，获取到处理的结果
    MockMvc mockMvc;

    @Before
    public void initMockMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
//        模拟请求，并拿到返回值
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "5")).andReturn();

//    请求成功以后，请求域中会有pageInfo，可以取出pageInfo进行验证
        MockHttpServletRequest request = result.getRequest();
        PageInfo pi =(PageInfo) request.getAttribute("pageInfo");
        System.out.println("当前页码：" + pi.getPageNum());
        System.out.println("总页码：" + pi.getPages());
        System.out.println("总记数：" + pi.getTotal());
        System.out.print("在页面需要连续显示的页码：");
        int[] nums = pi.getNavigatepageNums();
        for(int i : nums){
            System.out.print(" " + i);
        }
        System.out.println();
//        获取员工数据
        List<Employee> list = pi.getList();
        for(Employee emp : list){
            System.out.println("员工ID：" + emp.getEmpId() + " 员工姓名：" + emp.getEmpName());
        }


    }

}
