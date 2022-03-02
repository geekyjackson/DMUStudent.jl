@testset "HW5" begin
    using DMUStudent.HW5: mc
    using CommonRLInterface
    using Compose

    @test mc isa AbstractEnv
    easier_env = Wrappers.QuickWrapper(mc,
        actions = [-1.0, 0.0, 1.0],
        observe = env->observe(env)[1:2]
    )
    A = actions(easier_env)
    done = false
    rsum = 0.0
    reset!(easier_env)
    s = observe(easier_env)
    t = 1
    γ = 0.95
    max_t = 200
    while t <= max_t && !terminated(easier_env)
        a = rand(A)
        
        r = act!(easier_env, a)
        sp = observe(easier_env)
       
        rsum += γ^t*r
        
        s = sp
        t += 1
    end
    @test -5.0 <= rsum <= 15000.0

    # rendering
    rndr = render(easier_env)
    @test rndr isa Context
    sprint((io, x)->show(io, MIME("text/html"), x), rndr)

    @test HW5.evaluate(s->0.0).score < 0.0
    @test HW5.evaluate(s->0.0, "zachary.sunberg@colorado.edu").score < 0.0
    @test HW5.evaluate(s->rand(actions(easier_env)), "zachary.sunberg@colorado.edu").score < 0.0

    # test whether it has enough energy
    disc = 1.0
    rsum = 0.0
    mc.s = [1.56, 0.0]
    while !terminated(mc) && disc > 0.001
        r = act!(mc, -1.0)
        rsum += disc*r
        disc *= 0.99
    end
    @test rsum > 200.0

    disc = 1.0
    rsum = 0.0
    mc.s = [1.4, 0.0]
    while !terminated(mc) && disc > 0.001
        r = act!(mc, -1.0)
        rsum += disc*r
        disc *= 0.99
    end
    @test rsum < 0.0

    # test breakout completion
    disc = 1.0
    rsum = 0.0
    reset!(mc)
    deleteat!(mc.veuxjs, 1:length(mc.veuxjs))
    r = act!(mc, -1.0)
    @test r > 10000
    @test mc.gameover == true

    reset!(mc)
    mc.s = [1.0, 0.0]
    act!(mc, 0.0)
    @test mc.nar.centerx < 200-17
    @test mc.nar.right < 200
    mc.s = [-1.0, 0.0]
    act!(mc, 0.0)
    @test mc.nar.centerx > 17
    @test mc.nar.left > 0
end
