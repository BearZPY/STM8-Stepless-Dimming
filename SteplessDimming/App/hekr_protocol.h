#ifndef	_HEKR_PROTOCOL_H_
#define	_HEKR_PROTOCOL_H_


// HEKR USER API **************************************************************

//ʹ��ǰҪȷ���û�����Ҫ���������  Ĭ��Ϊ100 ����100��Ҫ�����޸�
//�����С���������޸�Ϊ�����  
//����ж������ȳ�����  ȡ�����  Ϊ�û����ݳ���  ����֡����
//#define USER_MAX_LEN 0x64u

//Hekr Э���ʼ��
//ʹ��HekrЭ��ǰ����ɳ�ʼ��
//��ʼ����Ҫ�û��д��ڷ���һ��byte�ĳ���
//eg:  void UART_SendChar(u8 ch); �����������ֻ��һ��8bit����
//     �ú�����Ҫ�û������ڳ����ж���
//HekrInit����:
//�������Ϊ�û����ڷ���һ��byte�����ĺ�����
//void HekrInit(void (*fun)(unsigned char));
//eg:  HekrInit(UART_SendChar);   

//���봮�ڽ��յ���������  
//����ֵ��ͷ�ļ� RecvDataHandleCode
//�������鳤��Ӧ�����û����ݳ��ȼ���HEKR_DATA_LEN
//���ݱ����ڶ�Ӧ������ valid_data �� ModuleStatus ָ��
//unsigned char HekrRecvDataHandle(unsigned char* data);

//���ü���ѯhekrģ��״̬ ������ֵ��ͷ�ļ� HekrModuleControlCode
//״ֵ̬������module_status������
//void HekrModuleControl(unsigned char data);


//�ϴ��û���Ч����
//���ݴ����valid_data������ len Ϊ�û����ݳ���  ����֡����
//void HekrValidDataUpload(unsigned char len);

//Э���޸����� 2015.09.01 
//Э����ַ  http://docs.hekr.me/protocol/
//BUG ����  pengyu.zhang@hekr.me
//					965006619@qq.com
//*****************************************************************************



#define USER_MAX_LEN 0x20u
#define HEKR_DATA_LEN 0x05u
#define HEKR_FRAME_HEADER 0x48u


//*************************************************************************
//
//ModuleStatus ָ�� ��������
//
//*************************************************************************

//ģ��Ӧ��֡��ʽ
typedef struct
{
	//��Ч����
	unsigned char CMD;
	unsigned char Mode;
	unsigned char WIFI_Status;
	unsigned char CloudStatus;
	unsigned char SignalStrength;// 0-5 �����ź�ǿ��
	unsigned char Reserved;
}ModuleStatusFrame; 


//*************************************************************************
//
//HekrRecvDataHandle  ��������ֵ
//
//*************************************************************************

typedef	enum
{
	RecvDataSumCheckErr = 0x01,
	LastFrameSendErr = 0x02,
	MCU_UploadACK = 0x03,
	ValidDataUpdate = 0x04,
	RecvDataUseless = 0x05,
	HekrModuleStateUpdate = 0x06,
	MCU_ControlModuleACK = 0x07
}RecvDataHandleCode;



//Hekrģ�������
typedef	enum
{
	ModuleQuery = 0x01,
	ModuleRestart = 0x02,
	ModuleRecover = 0x03,
	HekrConfig = 0x04
}HekrModuleControlCode;


//*************************************************************************
//
//ModuleStatus ָ���и�����Чλ������ֵ
//
//*************************************************************************

//Hekrģ��״̬��
typedef	enum
{
	STA_Mode = 0x01,
	HekrConfig_Mode = 0x02,
	AP_Mode = 0x03,
	STA_AP_Mode = 0x04,
	RF_OFF_Mode = 0x05
}HekrModuleWorkCode;

//Hekr WIFI״̬��
typedef	enum
{
	RouterConnected = 0x01,
	RouterConnectedFail = 0x02,
	RouterConnecting = 0x03,
	PasswordErr = 0x04,
	NoRouter = 0x05,
	RouterTimeOver = 0x06
}HekrModuleWIFICode;

//Hekr Cloud״̬��
typedef	enum
{
	CloudConnected = 0x01,
	DNS_Fail = 0x02,
	CloudTimeOver = 0x03
}HekrModuleCloudCode;


//*************************************************************************
//�û�������
//*************************************************************************

extern unsigned char valid_data[USER_MAX_LEN];
extern ModuleStatusFrame *ModuleStatus; 


//*************************************************************************
//�����б�
//*************************************************************************

// Hekr USER API 
void HekrInit(void (*fun)(unsigned char));
unsigned char HekrRecvDataHandle(unsigned char* data);
void HekrModuleControl(unsigned char data);
void HekrValidDataUpload(unsigned char len);


#endif
