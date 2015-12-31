package models;

import java.util.ArrayList;
import java.util.List;

import com.et.ar.ActiveRecordBase;
import com.et.ar.annotations.Column;
import com.et.ar.annotations.Id;
import com.et.ar.annotations.Table;
import com.et.ar.exception.ActiveRecordException;

@Table(name="intercourseTypes")
public class IntercourseType extends ActiveRecordBase{
	@Id private Integer id;
	@Column private Integer parentId;
	@Column private String code;
	@Column private String name;
	@Column private String remark;
	@Column private Integer sort;
	
	public void beforeDestroy() throws ActiveRecordException{
		for(IntercourseType type: findAll(IntercourseType.class, "parentId=?", new Object[]{id})){
			type.destroy();
		}
	}
	
	public String findChildIds() throws Exception{
		String s = "";
		List<Integer> ids = new ArrayList<Integer>();
		ids.add(id);
		while(!ids.isEmpty()){
			int id = ids.remove(0);
			s += id + ",";
			for(IntercourseType type: findAll(IntercourseType.class, "parentId=?", new Object[]{id})){
				ids.add(type.getId());
			}
		}
		if (!s.equals("")){
			s = s.substring(0, s.length() - 1);
		}
		return s;
	}
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getParentId() {
		return parentId;
	}
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public Integer getSort() {
		return sort;
	}
	public void setSort(Integer sort) {
		this.sort = sort;
	}

}
