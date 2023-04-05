unsigned short Fibonacci(short N)
{
	/* This function computes Nth Fibonacci 
number.

	  Fibonacci series is as follows:
	    1, 1, 2, 3, 5, 8, 13, 21, 34, 55, ...	*/

  unsigned short i, old_last, last, before_last;

  last = 1;
  before_last = 1;

  for (i=2 ;  i < N ; i++)
  {
    old_last = last;
    last = last + before_last;
    before_last = old_last;
  }

  return last;
}
