/* [ANS-db3l] Change this to a config'd request for a replacement function */
/* since later Sun systems have this and on other systems not explicitly   */
/* checked here such as FreeBSD/BSDI it would crash on perror() calls.	   */

#ifdef STRERROR

/* standin for strerror(3) which is missing on some systems
 * (eg, SUN)
 */

char *
strerror(int num)
{
	perror(num);
	return "";
}    

#endif
