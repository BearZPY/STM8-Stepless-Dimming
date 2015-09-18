#include "hekr_protocol.h"

//*************************************************************************
//Hekr ������ֵ
//*************************************************************************


//ͨ��֡ͷ��ʽ 
typedef struct
{
	unsigned char header;
	unsigned char length;
	unsigned char type;
	unsigned char number;
}GeneralHeader;


//Hekr��֡����
typedef	enum
{
	ModuleQueryFrameLength = 0x07,
	ModuleResponseFrameLength = 0x0B,
	ErrorFrameLength = 0x07
}AllFrameLength;

//Hekr��֡����
typedef	enum
{
	DeviceUploadType = 0x01,
	ModuleDownloadType = 0x02,
	ModuleOperationType = 0xFE,
	ErrorFrameType = 0xFF
}AllFrameType;


//Hekr������ȡֵ
typedef	enum
{
	ErrorOperation = 0x01,
	ErrorSumCheck = 0x02,
	ErrorDataRange = 0x03,
	ErrorNoCMD = 0xFF
}AllErrorValue;



//ģ���ѯ֡��ʽ
typedef struct
{
	//ͨ��֡ͷ
	GeneralHeader header;
	//��Ч����
	unsigned char CMD;
	unsigned char Reserved;
	//��У��
	unsigned char SUM;
}ModuleQueryFrame; 


//����֡��ʽ
typedef struct
{
	//ͨ��֡ͷ
	GeneralHeader header;
	//��Ч����
	unsigned char ErrorCode;
	unsigned char Reserved;
	//��У��
	unsigned char SUM;
}ErrorFrame; 

//*************************************************************************
//Hekr �������
//*************************************************************************

// �ڲ�����
static unsigned char hekr_send_buffer[USER_MAX_LEN+HEKR_DATA_LEN];
static unsigned char module_status[10];
static unsigned char frame_no = 0;
static void (*hekr_send_btye)(unsigned char);

// �ṩ�û�ʹ��
ModuleStatusFrame *ModuleStatus = (ModuleStatusFrame*)&module_status;
unsigned char valid_data[USER_MAX_LEN];

//*************************************************************************
//Hekr �ڲ���������
//*************************************************************************

// Static Function
static void HekrSendByte(unsigned char ch);
static void HekrSendFrame(unsigned char *data);
static unsigned char SumCheckIsErr(unsigned char* data);
static void ErrResponse(unsigned char data);
static unsigned char SumCalculate(unsigned char* data);
static void HekrValidDataCopy(unsigned char* data);
static void HekrModuleStateCopy(unsigned char* data);

//*************************************************************************
//Hekr ��������
//*************************************************************************

// �û�����
void HekrInit(void (*fun)(unsigned char))
{	
	hekr_send_btye = fun;
}

unsigned char HekrRecvDataHandle(unsigned char* data)
{
	//����У��
	if(SumCheckIsErr(data))
	{
		ErrResponse(ErrorSumCheck);
		return RecvDataSumCheckErr;
	}
	//ȷ��֡����
	switch(data[2])
	{
	case DeviceUploadType://MCU�ϴ���Ϣ���� ����Ҫ���� 
	                        return MCU_UploadACK;
	case ModuleDownloadType://WIFI�´���Ϣ
	                        HekrSendFrame(data);
	                        HekrValidDataCopy(data);
	                        return ValidDataUpdate;
	case ModuleOperationType://Hekrģ��״̬
													if(data[1] != ModuleResponseFrameLength)
														return MCU_ControlModuleACK;
	                        HekrModuleStateCopy(data);
	                        return HekrModuleStateUpdate;
	case ErrorFrameType://��һ֡���ʹ���	
	                        return LastFrameSendErr;
	default:ErrResponse(ErrorNoCMD);break;
	}
	return RecvDataUseless;
}

void HekrValidDataUpload(unsigned char len)
{
	unsigned char i;
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = len + 5;;
	hekr_send_buffer[2] = DeviceUploadType;
	hekr_send_buffer[3] = frame_no++;
	for(i = 0; i < len ; i++)
		hekr_send_buffer[i+4] = valid_data[i];
	HekrSendFrame(hekr_send_buffer);
}

void HekrModuleControl(unsigned char data)
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ModuleQueryFrameLength;
	hekr_send_buffer[2] = ModuleOperationType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = data;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}


// �ڲ�����
static void HekrSendByte(unsigned char ch)
{
	hekr_send_btye(ch);
}


static void HekrSendFrame(unsigned char *data)
{
	unsigned char len = data[1];
	unsigned char i = 0;
	data[len-1] = SumCalculate(data);
	for(i = 0 ; i < len ; i++)
	{
		HekrSendByte(data[i]);
	}
}

static unsigned char SumCheckIsErr(unsigned char* data)
{
	unsigned char temp = SumCalculate(data);
	unsigned char len = data[1] - 1;
	if(temp == data[len])
		return 0;
	return 1;
}

static unsigned char SumCalculate(unsigned char* data)
{
	unsigned char temp;
	unsigned char i;
	unsigned char len = data[1] - 1;
	temp = 0;
	for(i = 0;i < len; i++)
	{
			temp += data[i];
	}
	return temp;
}

static void ErrResponse(unsigned char data)
{
	hekr_send_buffer[0] = HEKR_FRAME_HEADER;
	hekr_send_buffer[1] = ErrorFrameLength;
	hekr_send_buffer[2] = ErrorFrameType;
	hekr_send_buffer[3] = frame_no++;
	hekr_send_buffer[4] = data;
	hekr_send_buffer[5] = 0x00;
	HekrSendFrame(hekr_send_buffer);
}

static void HekrValidDataCopy(unsigned char* data)
{
	unsigned char len,i;
	len = data[1]- HEKR_DATA_LEN;
	for(i = 0 ;i < len ; i++)
		valid_data[i] = data[i+4];
}

static void HekrModuleStateCopy(unsigned char* data)
{
	unsigned char len,i;
	len = data[1]- HEKR_DATA_LEN;
	for(i = 0 ;i < len ; i++)
		module_status[i] = data[i+4];
}


