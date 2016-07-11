#ifdef __cplusplus
extern "C" {
#endif
	
int sqlRun(int index, const char* query, void (*closure)(const char *data, ...));
	

#ifdef __cplusplus
}
#endif