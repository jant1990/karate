/*
 * The MIT License
 *
 * Copyright 2018 Intuit Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.intuit.karate.core;

import com.intuit.karate.StepActions;
import java.util.Collections;
import java.util.Iterator;

/**
 *
 * @author pthomas3
 */
public class ScenarioExecutionUnit {

    private final StepActions actions;
    private final ExecutionContext exec;
    private final Iterator<Step> iterator;
    private final ScenarioResult result;

    private boolean stopped = false;

    public ScenarioExecutionUnit(Scenario scenario, StepActions actions, ExecutionContext exec) {
        this.actions = actions;
        this.exec = exec;
        result = new ScenarioResult(scenario);
        // before-scenario hook
        boolean hookFailed = false;
        if (actions.callContext.executionHook != null) {
            try {
                actions.callContext.executionHook.beforeScenario(scenario, actions.context);
            } catch (Exception e) {
                hookFailed = true;
                result.addError(e);
            }
        }
        iterator = hookFailed ? Collections.emptyIterator() : scenario.getStepsIncludingBackground().iterator();
    }

    public void submit(Runnable next) {
        if (iterator.hasNext()) {
            Step step = iterator.next();
            if (stopped) {
                result.addStepResult(new StepResult(step, Result.skipped(), null, null));
                ScenarioExecutionUnit.this.submit(next);
            } else {
                exec.system.accept(() -> {
                    StepExecutionUnit unit = new StepExecutionUnit(step, actions, exec);
                    unit.submit(stepResult -> {
                        result.addStepResult(stepResult);
                        if (stepResult.isStopped()) {
                            stopped = true;
                        }
                        ScenarioExecutionUnit.this.submit(next);
                    });
                });
            }
        } else {
            // this has to be done at the end after they are fully populated
            // else the feature-result will not "collect" stats correctly 
            exec.result.addResult(result);
            // after-scenario hook
            if (actions.callContext.executionHook != null) {
                actions.callContext.executionHook.afterScenario(result, actions.context);
            }
            next.run();
        }
    }

}
