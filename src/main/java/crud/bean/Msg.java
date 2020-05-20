package crud.bean;


import java.util.HashMap;
import java.util.Map;

/**
 * 用来返回json的数据的通用类
 */
public class Msg {

//    状态码，100成功，200失败
    private int code;
//    提示信息
    private String msg;
//    用户要返回给浏览器的数据
    private Map<String, Object> extend = new HashMap<String, Object>();

    public static Msg success(){
        Msg res = new Msg();
        res.setCode(100);
        res.setMsg("处理成功!");
        return res;
    }

    public static Msg fail(){
        Msg res = new Msg();
        res.setCode(200);
        res.setMsg("处理失败!");
        return res;
    }

    public Msg add(String key, Object value){
        this.getExtend().put(key, value);
        return this;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }
}
