/*=====================================================================================
ģ����  ��
�ļ���  ��string.h
����ļ���
ʵ�ֹ��ܣ�ʵ��string��
����    ��������(bao.z.h.2008@gmail.com)
��Ȩ    ��
---------------------------------------------------------------------------------------
�޸ļ�¼��
����        �汾    �޸���      �߶���      �޸ļ�¼
2014/1/4   V1.0    ������                    ����
========================================================================================*/


#include <utility>
#include <string.h>


class String
{
public:
	String() : m_pData(new char[1])
	{
		*m_pData = '\0';
	}
	
	String(const char* str) : m_pData(new char[strlen(str) + 1])
	{
		strcpy(m_pData, str);
	}
	
	String(const String& rhs) : m_pData(new char[rhs.size() + 1])
	{
		strcpy(m_pData, rhs.c_str());
	}
	
	~String()
	{
		delete[] m_pData;
	}
	
	String& operator=(String rhs) // yes, pass-by-value
	{
		swap(rhs);
		return *this;
	}
	
	// Accessors
	size_t size() const
	{
		return strlen(m_pData);
	}
	
	const char* c_str() const
	{
		return m_pData;
	}
	
	void swap(String& rhs)
	{
		std::swap(m_pData, rhs.m_pData);
	}
	
private:
	char* m_pData;
};





