#ifndef _UVMOS_OUTER_API_H_
#define _UVMOS_OUTER_API_H_

#ifdef  __cplusplus
extern "C" {
#endif

/**
* �����ṩ��ö��ֵ���޷�ȷ��ʱĬ��ΪFFMPEG
*/
typedef enum _UvMOSContentProvider {
	CONTENT_PROVIDER_FFMPEG	 = 0,	// ��Ƶ���ݲ��ÿ�Դffmpeg���� 
	CONTENT_PROVIDER_HUAWEI	 = 1,	// ��Ƶ���ݲ���HW���б����� 
	CONTENT_PROVIDER_YOUTUBE = 2,	// ��Ƶ��������YOUTUBE 
	CONTENT_PROVIDER_YOUKU	 = 3,	// ��Ƶ���������ſ� 
	CONTENT_PROVIDER_TENCENT = 4,	// ��Ƶ����������Ѷ 
	CONTENT_PROVIDER_SOHU	 = 5,	// ��Ƶ���������Ѻ� 
	CONTENT_PROVIDER_IQIY	 = 6,	// ��Ƶ�������԰����� 
	CONTENT_PROVIDER_YOUPENG = 7,	// ��Ƶ������������ 
	CONTENT_PROVIDER_OTHER	 = 8	// ��Ƶ�����������������ṩ�� 
}UvMOSContentProvider;

/**
 * ��Ƶ/��Ļ�ֱ���ö��ֵ���ݲ�֧�ַǱ�׼�ֱ���
 */
typedef enum _UvMOSVideoResolution {
	RESOLUTION_360P	  = 0,	// �ֱ���360P, 480*360 
	RESOLUTION_480P	  = 1,	// �ֱ���480P, 640*480 
	RESOLUTION_720P	  = 2,	// �ֱ���720P, 1280*720 
	RESOLUTION_1080P  = 3,	// �ֱ���720P, 1920*1080 
	RESOLUTION_2K	  = 4,	// �ֱ���2K, 2560��1440 
	RESOLUTION_4K	  = 5,	// �ֱ���4K, 3840��2160 
	RESOLUTION_UNKNOW = 6	// �ֱ����޷���ȡ����Ƶ�ֱ����޷���ȡʱ�����޷�����UvMOS���㣬��Ļ�ֱ����޷���ȡʱ����������Ӱ�� 
}UvMOSVideoResolution;

/**
* ��Ƶ�����ʽö��ֵ���޷�ȷ��ʱĬ��ΪH264
*/
typedef enum _UvMOSVideoCodec {
	VIDEO_CODEC_H264  = 0,	// ��Ƶ�����ʽH264 
	VIDEO_CODEC_H265  = 1,	// ��Ƶ�����ʽH265/HEVC����ǰ�汾ֻ֧�ֱַ���720P������ 
	VIDEO_CODEC_VP9	  = 2,	// ��Ƶ�����ʽVP9 
	VIDEO_CODEC_H263  = 3,	// ��Ƶ�����ʽH263����ǰ�汾��ʱ��֧�� 
	VIDEO_CODEC_MP4	  = 4,	// ��Ƶ�����ʽMP4����ǰ�汾��ʱ��֧�� 
	VIDEO_CODEC_OTHER = 5	// ������Ƶ�����ʽ����ǰ�汾��ʱ��֧�� 
}UvMOSVideoCodec;

/**
* UvMOS������
*/
#ifndef _UVMOS_OUTER_API_ERROR_CODE_
#define _UVMOS_OUTER_API_ERROR_CODE_
typedef enum _UvMOSErrorCode {
	SUCCESS				 =  0,
	INVAILD_PARAMS		 = -1,
	OUT_OF_MEMORY		 = -2,
	UVMOS_ENGINE_FAILED  = -3,
	INVAILD_SERVICE_ID   = -4,
	ANALYSIS_DATA_FAILED = -5
}UvMOSErrorCode;
#endif

/**
 * ý�������Ϣ
 */
typedef struct _UvMOSMediaInfo
{
	UvMOSContentProvider eContentProvider;	// �����ṩ�̣�ȡֵ���ö������UvMOSContentProvider 

	UvMOSVideoResolution eVideoResolution; 	// ��Ƶ�ֱ��ʣ�ȡֵ���ö������UvMOSVideoResolution --��Ҫ���Ƿֱ�������Ӧ 
	unsigned int iFrameRate;				// ��Ƶ֡�� 
	unsigned int iAvgBitrate;				// ý���ļ�ƽ�����ʣ���λkbps --ý���ļ���������
	UvMOSVideoCodec eVideoCodec;			// ��Ƶ�����ʽ��ȡֵ���ö������UvMOSVideoCodec 

	float fScreenSize;						// ��Ļ�ߴ磬��λӢ�磬����Ϊ0ʱ����Ļӳ��Ĭ��Ϊ42��TV 
	UvMOSVideoResolution eScreenResolution;	// ��Ļ�ֱ��ʣ�ȡֵ���ö������UvMOSVideoResolution 
}UvMOSMediaInfo;

/**
 * VOD����������Ϣ
 */
typedef struct _UvMOSVODPeriodInfo
{
	unsigned int iPeriodLength;			// ��������ʱ������λ��(s)�����鰴�չۿ�ʱ�䷴�������ƿ��԰������ݵ�ʵ��ʱ�䷴��

	unsigned int iInitBufferLatency;	// ��ʼ����ʱ������λ����(ms)�����������ڳ�ʼ�����¼�δ��ɣ������������û�г�ʼ�����¼�ʱ������Ϊ0

	unsigned int iAvgVideoBitrate;		// ֧��VBR����ʱ��������������Ƶ�ļ�ƽ�����ʣ���λkbps���޷����ʱ������Ϊ0
	unsigned int iAvgKeyFrameSize;		// ֧��VBR����ʱ������������I֡ƽ����С����λ�ֽڣ��޷����ʱ������Ϊ0

	unsigned int iStallingFrequency;	// ���������ڣ����ٴ���
	unsigned int iStallingDuration;		// ���������ڣ�ƽ������ʱ������λ����(ms)
	unsigned int iStallingInterval;		// ���������ڣ�ƽ�����ټ������λ����(ms)
}UvMOSVODPeriodInfo;

/** 
 * UvMOS������
 */
typedef struct _UvMOSResult 
{
	double sQualityPeriod;		// ��Ƶ�������ڷ�����1��5��
	double sInteractionPeriod;	// �����������ڷ�����1��5��
	double sViewPeriod;			// �ۿ��������ڷ�����1��5�� 
	double uvmosPeriod;			// ��Ƶ��������UvMOS�÷֣�1��5��

	double sQualitySession;		// ��Ƶ�����Ự������1��5�� 
	double sInteractionSession;	// ��������Ự������1��5�� 
	double sViewSession;		// �ۿ�����Ự������1��5�� 
	double uvmosSession;		// ��Ƶ�ӿ�ʼ���ŵ����ڵ�UvMOS�÷֣�1��5��
}UvMOSResult;

/**
 * DLL����������ע��UvMOS����
 *
 * @Parameters ���������pMediaInfo ý����Ϣ
 *
 * @Return �ɹ����ط���ID��ʧ�ܷ��� -1 
 */
 int  registerUvMOSService(UvMOSMediaInfo *pMediaInfo);

/**
 * DLL��������������ָ���ķ���ID��ע��UvMOS����
 *
 * @Param iServiceId �������������ID
 *
 * @Return �ɹ�����0��ʧ�ܷ��� -1 
 */
int  unregisterUvMOSService(int iServiceId);

/**
 * DLL�������������ݷ���ID��VOD������Ϣ������UvMOS�÷�
 *
 * @Param iServiceId �������������ID
 * @Param pVODPeriodInfo ���������VOD������Ϣ
 * @Param pUvMOSResult �������������UvMOS������
 *
 * @Return �ɹ�����0��ʧ�ܷ���-1
 */
int calculateUvMOSVODPeriod(int iServiceId, UvMOSVODPeriodInfo *pVODPeriodInfo, UvMOSResult *pUvMOSResult);

#ifdef __cplusplus
}
#endif
#endif