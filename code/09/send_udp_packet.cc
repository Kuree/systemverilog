// send_udp_packet.cc
// don't forget to include the header file since we're using array
#include "svdpi.h"
#include <vector>

std::vector<char> read_data(svOpenArrayHandle array) {
    // notice the argument type is svOpenArrayHandle
    std::vector<char>  result;
    // get loop bound
    auto low = svLeft(array, 1);
    auto high = svRight(array, 1);
    // get size and reserve the vector
    auto size = svSize(array, 1);
    result.reserve(size);

    for (auto i = low; i <= high; i++) {
        auto *value = reinterpret_cast<char*>(svGetArrElemPtr1(array, i));
        result.emplace_back(*value);
    }

    return result;
}


extern "C" {
int send_udp_packet(const char *ip_address, uint16_t unsigned port, svOpenArrayHandle data) {
    auto byte_data = read_data(data);

    // do something with the data, ip address, and port
    return 0;
}
}
