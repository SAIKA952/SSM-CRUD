package crud.service;

import crud.bean.Department;
import crud.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department> getDepts() {
//        查询所有部门，不用加条件
        List<Department> list = departmentMapper.selectByExample(null);
        return list;
    }
}
