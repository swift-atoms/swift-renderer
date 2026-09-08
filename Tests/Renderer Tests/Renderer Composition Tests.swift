import Renderer
import Testing

@Suite struct `Renderer composition preserves effect order and typed failures` {
    enum Failure: Error, Equatable { case stopped(Int) }

    struct Step: Renderer.`Protocol` {
        let index: Int
        let stop: Int

        func render(_ input: borrowing Int, into context: inout [Int]) throws(Failure) {
            context.append(input + index)
            if index == stop { throw .stopped(index) }
        }
    }

    func outcome<R: Renderer.`Protocol`>(
        _ renderer: borrowing R, into context: inout [Int]
    ) -> Failure? where R.Input == Int, R.Context == [Int], R.Failure == Failure {
        do {
            try renderer.render(10, into: &context)
            return nil
        } catch {
            return error
        }
    }

    @Test(arguments: [-1, 0, 1, 2])
    func `Array composition preserves failure and effect order`(stop: Int) {
        let operations = (0...2).map { Step(index: $0, stop: stop) }
        var context = [99]

        let failure = outcome(operations, into: &context)

        #expect(failure == (stop < 0 ? nil : .stopped(stop)))
        #expect(context == [99] + Array(10...(stop < 0 ? 12 : 10 + stop)))
    }

    @Test func `Empty arrays and absent operations leave the context unchanged`() {
        let empty: [Step] = []
        let absent: Step? = nil
        var context = [99]

        #expect(outcome(empty, into: &context) == nil)
        #expect(outcome(absent, into: &context) == nil)
        #expect(context == [99])
    }

    @Test(arguments: [-1, 0])
    func `Present optional operations preserve typed failures and effects`(stop: Int) {
        let operation = Step(index: 0, stop: stop)
        let optional: Step? = operation
        var direct = [99], wrapped = [99]

        let directFailure = outcome(operation, into: &direct)
        let optionalFailure = outcome(optional, into: &wrapped)

        #expect(directFailure == optionalFailure)
        #expect(direct == wrapped)
        #expect(wrapped == [99, 10])
    }

    @Test func `A witness invokes its operation once per render and propagates failure` () {
        var calls = 0
        let witness = Renderer.Witness<Int, [Int], Failure> { input, context throws(Failure) in
            calls += 1
            context.append(input)
            throw .stopped(input)
        }
        var context = [99]

        #expect(outcome(witness, into: &context) == .stopped(10))
        #expect(outcome(witness, into: &context) == .stopped(10))
        #expect(calls == 2)
        #expect(context == [99, 10, 10])
    }
}
