PLATFORM=MACSVN
#PLATFORM=CYGWIN
#PLATFORM=LINUX

#MODE=DEBUG
MODE=RELEASE

SRC_DIR=src/
OBJ_DIR=build/
BIN_DIR=bin/
INS_DIR=install/
INS_LIB=$(INS_DIR)lib/
INS_INC=$(INS_DIR)include/NMPT/

EXECUTABLES=FastSUN FastSUNImage SimpleSalienceExample FastSUNParameters \
	SimpleFaceTracker \
	FoveatedFaceTracker CVPRTrainModels CVPRTestSpeed TrainNarrowFOVModel \
	FoveatedFaceTrackerImage EstimateInternalMotion ChooseSaccadeTargets  \
	CreateBoostingInitialPatchDataset TrainCascadedDetector \
	TrackObjectsInScene TrainGentleBoost2 CreateBoostingInitialPatchDataset2
	
COMMON_INCLUDES= BlockTimer ObjectDetector \
	OpenCVHaarDetector ImageDataSet ImagePatchPyramid \
	MultinomialObservationModel OpenLoopPolicies ConvolutionalLogisticPolicy \
	MIPOMDP Feature BoxFeature HaarFeature \
	FeatureRegressor  ImagePatch PatchDataset GentleBoostClassifier \
	GentleBoostCascadedClassifier FastPatchList PatchList InternalMotionModel \
	MultiObjectTrackingState DetectionEvaluator MatrixKalmanFilter \
	ImageKalmanFilter LQRPointTracker KFPointTracker StructTypes KF LQR \
	NMPTUtils OpenCV2BoxFilter FastSalience GentleBoostClassifier2 \
	Feature2 BoxFeature2 HaarFeature2 FeatureRegressor2 ImagePatch2 \
	PatchList2 FastPatchList2 ImageDataSet2 DetectionEvaluator2 \
	PatchDataset2 
MM_INCLUDES=NCvCapture


C_SOURCES=$(COMMON_INCLUDES:%=${SRC_DIR}%.cpp) 
MM_SOURCES=$(MM_INCLUDES:%=${SRC_DIR}%.mm)
C_OBJECTS=$(COMMON_INCLUDES:%=${OBJ_DIR}%.o) 
MM_OBJECTS=$(MM_INCLUDES:%=${OBJ_DIR}%.o)
#COMMON_SOURCES=$(C_SOURCES) $(MM_SOURCES)
#COMMON_OBJECTS=$(C_OBJECTS) $(MM_OBJECTS)
COMMON_SOURCES=$(C_SOURCES)
COMMON_OBJECTS=$(C_OBJECTS)
BINARIES=$(EXECUTABLES:%=${BIN_DIR}%)
 

CFLAGS=-Wall 
RELEASEFLAGS=-O3 -ffast-math -funroll-loops 
DEBUGFLAGS=-O0 -g 
LDFLAGS=
CUSTOM_INCLUDES=
CUSTOM_LIBRARIES=
#FRAMEWORKS=-framework QTKit -framework Foundation -framework QuartzCore -framework AppKit -framework Phidget21

ifeq ($(MODE), DEBUG)
	CFLAGS+=${DEBUGFLAGS}
endif

ifeq ($(MODE), RELEASE)
	CFLAGS+=${RELEASEFLAGS}
endif

ifeq ($(PLATFORM), CYGWIN)
	CC = g++
	OPENCV=/cygdrive/c/Program\ Files/OpenCV
	CUSTOM_INCLUDES+=-I${OPENCV}/cvaux/include -I${OPENCV}/cxcore/include -I${OPENCV}/cv/include -I${OPENCV}/ml/include -I${OPENCV}/otherlibs/highgui -I${SRC_DIR}
	CUSTOM_LIBRARIES+= -L${OPENCV}/lib -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_objdetect 
endif

ifeq ($(PLATFORM), LINUX)
	CC = g++
	OPENCV=/usr/local
	CUSTOM_INCLUDES+=-I${OPENCV}/include/ -I${SRC_DIR}
	CUSTOM_LIBRARIES+= -L${OPENCV}/lib -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_objdetect
endif

ifeq ($(PLATFORM), MACSVN)
	CC = g++
	OPENCV=/usr/local
	CUSTOM_INCLUDES+=-I${OPENCV}/include/ -I${SRC_DIR}
	CUSTOM_LIBRARIES+= -L${OPENCV}/lib -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_objdetect 
endif

ifeq ($(PLATFORM), MACFRAMEWORK)
	CC = g++
	CFLAGS+=-arch i386 
	OPENCV=/Library/Frameworks/OpenCV.framework
	CUSTOM_INCLUDES+=-I${OPENCV}/Headers/ -I${SRC_DIR} 
	CUSTOM_LIBRARIES+=-framework OpenCV ${FRAMEWORKS}
endif

all:  $(COMMON_OBJECTS) install $(BINARIES) 

${C_OBJECTS}: $(OBJ_DIR)%.o: $(SRC_DIR)%.cpp 
	${CC} -c $< ${CFLAGS} ${CUSTOM_INCLUDES} -o $@

$(MM_OBJECTS): $(OBJ_DIR)%.o: $(SRC_DIR)%.mm 
	${CC} -c $< ${CFLAGS} ${CUSTOM_INCLUDES} -o $@

install: $(COMMON_OBJECTS)
	ar rcs $(INS_LIB)libnmpt.a $(COMMON_OBJECTS)
	cp $(SRC_DIR)*.h $(INS_INC)
	
${BIN_DIR}%: ${SRC_DIR}%.cpp $(INS_LIB)libnmpt.a 
	${CC} $^ ${CFLAGS} ${CUSTOM_INCLUDES} ${LDFLAGS} ${CUSTOM_LIBRARIES} -o $@


clean: 
	rm -rf ${BIN_DIR}*
	rm -rf ${OBJ_DIR}*.o
	rm -rf ${INS_LIB}*
	rm -rf ${INS_INC}*.h 
