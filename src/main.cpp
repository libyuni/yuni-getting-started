
#include <yuni/yuni.h>
#include <yuni/core/string.h>
#include <yuni/core/system/suspend.h>
#include <yuni/thread/utility.h>
#include "logs.h"

using namespace Yuni;



int main()
{
	logs.info() << "Hello world !";

	uint counter = 0;
	auto timer = every(1000, [&] () -> bool {
		logs.info() << "counter: " << ++counter;
		return true; // continue looping
	});

	// wait for 5 seconds
	Suspend(5);

	// timer goes out of scope
	return 0;
}
