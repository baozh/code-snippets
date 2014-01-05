u16 ExecuteShell(LPCSTR pShellName, char *szFormat, ...)
{
#ifdef _LINUX_
	if(pShellName == NULL)
	{
		return SHELL_RET_FAIL;
	}
	
	s8 szParam[256] = {0};
	s8 szCommand[256*2] = {0};
	char szResult[256] = {0};
	FILE* fp = NULL;
	u32 dwRet = 0;
	
	va_list pvList;
	va_start(pvList, szFormat); 
	const u32 actLen = vsprintf(szParam, szFormat, pvList);   //把所有参数都存入szParam字符串中
	if((actLen <= 0) || (actLen >= sizeof(szParam)))
	{	
		return SHELL_RET_FAIL;
	}
	va_end(pvList);
	
	sprintf(szCommand, "%s %s", pShellName, szParam);    //执行shell脚本的命令
	TvmLog(ALL_LEVEL, "Execute Shell: %s\n", szCommand);
	
	fp = popen(szCommand, "r");         //以读方式，fork 产生一个子进程，执行shell命令
	if( fp == NULL)
	{
		return SHELL_RET_FAIL;
	}
	
	//为防止死循环，只取一次结果进行判断 成功为: result: 0
	fgets(szResult,sizeof(szResult),fp);                   //读取shell脚本中输出(stdout)的值，即用echo输出的东西。
	//while(fgets(szResult, sizeof(szResult),fp) != NULL){
	//	printf( "echo:%s", szResult);
	//}
	TvmLog(ALL_LEVEL, "Execute Result String: %s\n", szResult);
	
	pclose(fp);
	
	dwRet = atol(szResult);
	TvmLog(ALL_LEVEL, "Execute Result: %d\n", dwRet);
	if( dwRet != 1 )
	{		
		return SHELL_RET_FAIL;		
	}
#endif
	return SHELL_RET_OK;
}
