<body>
	<div class="x-nav">
		<span class="layui-breadcrumb">
		  <a><cite>首页</cite></a>
		  <a><cite>管理员管理</cite></a>
		  <a><cite>系统日志</cite></a>
		</span>
		<a class="layui-btn layui-btn-small" style="line-height: 1.6em; margin-top: 3px; float: right"  href="javascript:top.reload();" title="刷新"><i class="layui-icon" style="line-height:30px">ဂ</i></a>
	</div>
	<div class="x-body">
		<form class="layui-form x-center x-search-form" style="width:80%">
			<div class="layui-form-pane" style="margin-top: 15px;">
			  <div class="layui-form-item">
				<label class="layui-form-label">日期范围</label>
				<div class="layui-input-inline">
				  <input class="layui-input" placeholder="开始日" id="LAY_demorange_s" name="st" value="{{.Search.st}}">
				</div>
				<div class="layui-input-inline">
				  <input class="layui-input" placeholder="截止日" id="LAY_demorange_e" name="et" value="{{.Search.et}}">
				</div>
				<div class="layui-input-inline">
				  <input type="text" name="q"  placeholder="请输入关键字" autocomplete="off" class="layui-input" value="{{.Search.q}}">
				</div>
				<div class="layui-input-inline" style="width:80px">
					<button type="button" class="layui-btn" id="btn-search"><i class="layui-icon">&#xe615;</i></button>
				</div>
			  </div>
			</div> 
		</form>
		<xblock>
			<button class="layui-btn layui-btn-danger" onclick="del_all()"><i class="layui-icon">&#xe640;</i>批量删除</button>
			<span class="x-right" style="line-height:40px">共有数据：{{.LogCount}} 条</span>
		</xblock>
		<table class="layui-table">
			<thead>
				<tr>
					<th><input type="checkbox" name="" value="" class="all-select"></th>
					<th>ID</th>
					<th>类型</th>
					<th>内容</th>
					<th>用户名</th>
					<th>客户端IP</th>
					<th>时间</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				{{range .Logs}}
				<tr>
					<td><input type="checkbox" value="{{.Id}}" class="all-x-select"></td>
					<td>{{.Id}}</td>
					<td>{{.Type}}</td>
					<td>{{.Content}}</td>
					<td>{{.Name}}</td>
					<td>{{.Ip}}</td>
					<td>{{datetime .CreatedAt "2006-01-02 15:04"}}</td>
					<td class="td-manage">
						<a title="删除" href="javascript:;" onclick="log_del(this, '{{.Id}}')" style="text-decoration:none">
							<i class="layui-icon">&#xe640;</i>
						</a>
					</td>
				</tr>
				{{end}}
			</tbody>
		</table>
		<div id="page"></div>
	</div>

	<script>
		window.onload = function () {
			layui.use(['element', 'layer', 'laydate', 'laypage'], function() {
				var $ = layui.jquery;//jquery
				var laydate = layui.laydate;//日期插件
				var lement = layui.element;//面包导航
				var layer = layui.layer;//弹出层
				var laypage = layui.laypage;//分页

				// 分页
				laypage({
					cont: 'page',
					pages: {{.MaxPages}},
					last: {{.MaxPages}},
					curr: {{.Search.p}},
					first: 1,
					prev: '<em><</em>',
					next: '<em>></em>',
					skip: false,
					jump: function (obj, first) {
						if (first != true) {
							top.load_page({{urlfor "admin.AdminLogController.Index"}} + "?p=" + obj.curr + "&st={{.Search.st}}" + "&et={{.Search.et}}" + "&q={{.Search.q}}");
						}
					}
				}); 

				var start = {
					//min: laydate.now(-30),
					max: laydate.now(),
					istoday: false,
					start: laydate.now(-1),
					choose: function(datas) {
						end.min = datas; //开始日选好后，重置结束日的最小日期
						end.start = datas; //将结束日的初始值设定为开始日
					}
				};
				  
				var end = {
					//min: laydate.now(),
					max: laydate.now(),
					istoday: true,
					choose: function(datas) {
						start.max = datas; //结束日选好后，重置开始日的最大日期
					}
				};
				  
				document.getElementById('LAY_demorange_s').onclick = function() {
					start.elem = this;
					laydate(start);
				}
				document.getElementById('LAY_demorange_e').onclick = function() {
					end.elem = this
					laydate(end);
				}
			});

            $("#btn-search").click(function () {
                var query = $('.x-search-form').serialize();
                top.load_page({{urlfor "admin.AdminLogController.Index"}} + '?' + query);
            });
		}
		  
		// 批量删除提交
		function del_all() {
			layer.confirm('确认要删除吗？', function(index) {
                var ids = get_list_ids('all-x-select');
				//发异步删除数据
				ajax_post({{urlfor "admin.AdminLogController.DeleteBatch"}}, {ids: ids});
		    });
		}
	   
		/*-删除*/
		function log_del(obj, id) {
			layer.confirm('确认要删除吗？', function(index) {
				$(obj).parents("tr").remove();

				//发异步删除数据
				ajax_post({{urlfor "admin.AdminLogController.Delete"}}, {id: id});
			});
		}
		</script>
</body>
