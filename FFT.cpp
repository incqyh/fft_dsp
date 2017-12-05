#include <iostream>
#include <vector>
#include <complex>
#include <cmath>

using std::vector;
using std::complex;
using std::cout;
using std::cin;

const double PI = 3.1415926535898;

typedef vector<complex<double>> COMPLEX_SEQUENCE;

COMPLEX_SEQUENCE Reverse(COMPLEX_SEQUENCE input, int part);
COMPLEX_SEQUENCE FFT(COMPLEX_SEQUENCE input, bool flag = 1);
COMPLEX_SEQUENCE IFFT(COMPLEX_SEQUENCE input);

int main()
{
    int length, i;
    double inputBuffer;

    cout << "please input the length of the sequence:";
    cin >> length;
//    length = 16;
    COMPLEX_SEQUENCE input(length), output;

    cout << "Please input a valid sequence:\n";
    for (i = 0; i < length; ++i)
    {
        cin >> inputBuffer;
//        inputBuffer = i;
        input[i] = complex<double>(inputBuffer, 0);
    }
//    output = Reverse(input, 1);
    
    cout << "Raw sequence is:\n";
    for (i = 0; i < length; ++i)
        cout << input[i] << '\n';

    output = FFT(Reverse(input, 1));
    cout << "Result after FFT is:\n";
    for (i = 0; i < length; ++i)
        cout << output[i] << '\n';

    output = IFFT(Reverse(output, 1));
    cout << "Do IFFT and the result is:\n";
    for (i = 0; i < length; ++i)
        cout << output[i] << '\n';

    system("pause");
    return 0;
}


COMPLEX_SEQUENCE Reverse(COMPLEX_SEQUENCE input, int part)
{
    int p = input.size() / part;
    int i, j, k;
    COMPLEX_SEQUENCE tmp;
    for (i = 0; i < part; ++i)
    {
        tmp.clear();
        k = 0;
        for (j = p*i + 1; j < p*(i+1); j += 2)
            tmp.push_back(input[j]);
        for (j = p*i + 2; j < p*(i+1); j += 2)
            input[(j + p*i) / 2] = input[j];
        for (j = p*i + p / 2; j < p*(i + 1); j += 1)
            input[j] = tmp[k++];

    }
    if (p == 2) return input;
    else return Reverse(input, 2*part);
}

COMPLEX_SEQUENCE FFT(COMPLEX_SEQUENCE input, bool flag )
{
    for (complex<double> i : input)
        cout << i << '\n';
    cout << '\n';
    int N = input.size();
    COMPLEX_SEQUENCE tmpX[2] = { COMPLEX_SEQUENCE(N), COMPLEX_SEQUENCE(N) };
    complex<double> W;
    int i, j, k;
    bool ChooseSequence = 1;

    for (i = 0; i < N; ++i)
    {
        if (i % 2 == 0)
            tmpX[0][i] = input[i] + input[i + 1];
        else
            tmpX[0][i] = input[i - 1] - input[i];
    }
    for (i = 1; i < N/2; i *= 2 )
    {
        if (flag) W = complex<double>(cos(PI/(2*(double)i)), -sin(PI/(2*(double)i)));
        else W = complex<double>(cos(PI/(2*(double)i)), sin(PI/(2*(double)i)));
        for (j = 0; j < N / ( 4 * i ); ++j)
        {
            for (k = j*4*i; k < j*4*i + 2*i; ++k)
            {
                if (ChooseSequence)
                {
                    tmpX[1][k] = tmpX[0][k] + tmpX[0][k + 2*i] * pow(W, k);
                    tmpX[1][k + 2*i] = tmpX[0][k] - tmpX[0][k + 2*i] * pow(W, k);
                }
                else
                {
                    tmpX[0][k] = tmpX[1][k] + tmpX[1][k + 2*i] * pow(W, k);
                    tmpX[0][k + 2*i] = tmpX[1][k] - tmpX[1][k + 2*i] * pow(W, k);
                }
            }
        }
        ChooseSequence ^= 1;
        for (complex<double> i : tmpX[ChooseSequence])
            cout << i << '\n';
        cout << '\n';
    }
    if (ChooseSequence) return tmpX[0];
    return tmpX[1];
}

COMPLEX_SEQUENCE IFFT(COMPLEX_SEQUENCE input)
{
    COMPLEX_SEQUENCE tmp = FFT(input, 0);
    int N = tmp.size();
    for (int i = 0; i < N; ++i)
        tmp[i] /= N;
    return tmp;
}
