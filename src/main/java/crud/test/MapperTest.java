package crud.test;

import crud.bean.Department;
import crud.bean.Employee;
import crud.dao.DepartmentMapper;
import crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试dao层的工作
 * 推荐Spring的项目可以使用Spring的单元测试，可以自动注入我们需要的组件
 *
 * 1、导入SpringTest模块
 * 2、@ContextConfiguration指定Spring配置文件的位置
 *  ，@RunWith(SpringJUnit4ClassRunner.class)让测试运行于Spring测试环境
 * 3、直接autowired要使用的组件即可
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

//    批量的sqlSession
    @Autowired
    SqlSession sqlSession;

    /**
     * 测试DepartmentMapper
     */
    @Test
    public void testCRUD(){

////        1、创建SpringIOC容器
//        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
////        2、从容器中获取mapper
//        DepartmentMapper mapper = ac.getBean(DepartmentMapper.class);


        System.out.println(departmentMapper);

//        1、插入几个部门
//        departmentMapper.insertSelective(new Department(null,"开发部"));
//        departmentMapper.insertSelective(new Department(null,"测试部"));

//        2、生成员工数据
//        employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@123.com", 1));

//        3、批量插入多个员工，批量插入可以执行批量操作的SqlSession
//        for(){
//            employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@123.com", 1));
//        }
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for(int i = 0; i < 1000; i++){
            String uuid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uuid, "M", uuid + "@gmail.com", 1));
        }
        System.out.println("success!!");

    }

}
