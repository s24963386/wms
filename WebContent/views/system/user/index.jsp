<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>

<head>
	<style type="text/css">
		.e-input{
			width:198px;
			border:1px solid #A4BED4;
			height:18px;
			line-height:18px;
		}
	</style>
	<script type="text/javascript">
		$(function(){
			init();
		});
		function init(){
			$('#dlg').dialog({
				onOpen:function(){
					$('#dt-roles').datagrid('resize');
				}
			});
			$('#t-departments').tree({
				onClick: function(node){
					$('#t-users').datagrid('reload', {departmentId:node.id});
				}
			});
			
			// 扩展验证
			$.extend($.fn.validatebox.defaults.rules, {
				confirm:{
					validator: function(value,param){
						return value == $(param[0]).val();
					},
					message:'密码确认不对'
				}
			});
		}
		function formatDepartment(value,row){
			if (row.department){
				return row.department.name;
			} else {
				return value;
			}
		}

		var actionUrl;
		function newItem(){
			$('#dlg').dialog('setTitle', '新增用户资料').dialog('open');
			$('#myform').form('clear');
			$('#dt-roles').datagrid('clearSelections');
			actionUrl = '<c:url value="/system/user/save"/>';
		}
		function editItem(){
			var t = $('#t-users');
			var row = t.datagrid('getSelected');
			if (row){
				$('#myform').form('load', row);
				$('#confirmPassword').val(row.password);
				var dt = $('#dt-roles');
				dt.datagrid('clearSelections');
				if (row.roleIds){
					var ids = row.roleIds.split(',');
					for(var i=0; i<ids.length; i++){
						dt.datagrid('selectRecord', ids[i]);
					}
				}
				$('#dlg').dialog('setTitle', '修改用户资料').dialog('open');
				actionUrl = '<c:url value="/system/user/update"/>?id=' + row.id;
			}
		}
		function saveItem(){
			var ids = [];
			var roles = $('#dt-roles').datagrid('getSelections');
			for(var i=0; i<roles.length; i++){
				ids.push(roles[i].id);
			}
			$('#roleIds').val(ids.join(','));
			
			$('#myform').form('submit', {
				url:actionUrl,
				onSubmit:function(){
					return $('#myform').form('validate');
				},
				success:function(data){
					$('#dlg').dialog('close');
					$('#t-users').datagrid('reload');
				}
			});
		}
		
	</script>
</head>
<body>
	<div class="easyui-layout" fit="true">
		<div region="north" border="false">
			<div class="subtitle">用户管理</div>
			<div class="toolbar">
				<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newItem()">新增用户</a>
				<a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editItem()">修改用户</a>
			</div>
		</div>
		<div region="west" border="false" style="border-right:1px solid #92B7D0;width:150px;padding:5px;">
			<ul id="t-departments" url="<c:url value='/system/department/getItems'/>"></ul>
		</div>
		<div region="center" border="false">
			<table id="t-users" class="easyui-datagrid"
					url="<c:url value='/system/user/getItems'/>"
					singleSelect="true" rownumbers="true"
					border="false" fit="true">
				<thead>
					<tr>
						<th field="name" width="60" sortable="true">用户名称</th>
						<th field="sex" width="50">性别</th>
						<th field="departmentId" width="60" sortable="true" formatter="formatDepartment">所属部门</th>
						<th field="login" width="60">帐号</th>
						<th field="moNumber" width="80" sortable="true">手机号码</th>
						<th field="shortNumber" width="80" sortable="true">手机短号</th>
						<th field="inTime" width="80" sortable="true">入职日期</th>
						<th field="outTime" width="80" sortable="true">离职日期</th>
						<th field="roles" width="150">角色</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>
	
	<div id="dlg" style="width:600px;height:400px;"
			class="easyui-dialog" closed="true" modal="true" buttons="#dlg-buttons">
		<div style="padding:10px;">
			<div style="float:left">
				<form id="myform" method="post" style="margin:0;padding:0">
					<table>
						<tr>
							<td style="width:80px">用户名称</td>
							<td><input type="text" class="easyui-validatebox e-input" name="name" required="true"></input></td>
						</tr>
						<tr>
							<td>性别</td>
							<td>
								<select class="easyui-combobox" name="sex" panelHeight="60" style="width:60px">
									<option>男</option>
									<option>女</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>所属部门</td>
							<td>
								<input type="text" class="easyui-combotree"
										style="width:200px;"
										name="departmentId" 
										required="true"
										url="<c:url value='/system/department/getItems'/>">
							</td>
						</tr>
						<tr>
							<td>手机号码</td>
							<td><input type="text" class="e-input" name="moNumber"></input></td>
						</tr>
						<tr>
							<td>手机短号</td>
							<td><input type="text" class="e-input" name="shortNumber"></input></td>
						</tr>
						<tr>
							<td>入职时间</td>
							<td><input type="text" class="easyui-datebox e-input" name="inTime"></input></td>
						</tr>
						<tr>
							<td>离职时间</td>
							<td><input type="text" class="easyui-datebox e-input" name="outTime"></input></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>
								<input type="hidden" id="roleIds" name="roleIds">
							</td>
						</tr>
						<tr>
							<td>登录帐号</td>
							<td><input type="text" class="easyui-validatebox e-input" name="login" required="true"></input></td>
						</tr>
						<tr>
							<td>登录密码</td>
							<td><input type="password" class="easyui-validatebox e-input" id="password" name="password" required="true"></input></td>
						</tr>
						<tr>
							<td>确认密码</td>
							<td><input type="password" class="easyui-validatebox e-input" id="confirmPassword" name="confirmPassword" required="true" validType="confirm['#password']"></input></td>
						</tr>
					</table>
				</form>
			</div>
			<div style="float:right">
				<table id="dt-roles" class="easyui-datagrid" style="width:200px;height:200px;"
						url="<c:url value='/system/role/getRoles'/>"
						idField="id" fitColumns="true">
					<thead>
						<tr>
							<th field="ck" checkbox="true"></th>
							<th field="name" width="80">角色</th>
						</tr>
					</thead>
				</table>
			</div>
			<div style="clear:both"></div>
		</div>
		<div id="dlg-buttons" style="text-align:center;">
			<a href="#" class="easyui-linkbutton" iconCls="icon-save" onclick="saveItem()">保存</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
		</div>
	</div>
</body>
