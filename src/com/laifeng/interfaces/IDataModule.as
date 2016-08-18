package  com.laifeng.interfaces
{
	
	/**********************************************************
	 * IDataModule
	 * 
	 * Author         : mj
	 * Description :
	 * 			数据模块接口  所有数据模块必须实现此接口
	 * 
	 ***********************************************************/
	public interface IDataModule
	{
		function start():void;
		function destroy():void;
		
	}
}